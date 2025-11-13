import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/book_repo.dart';
import '../../data/repos/page_repo.dart';
import '../../data/storage/file_store.dart';
import '../../domain/services/download_service.dart';
import '../../domain/models/book.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

final _clientProvider = FutureProvider<KomgaClient>((_) => KomgaClient.create());
final _bookRepoProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => BookRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});
final _pageRepoProvider = Provider((_) => PageRepo());
final _fsProvider = Provider((_) => FileStore());
final _dlProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => DownloadService(
      client,
      ref.watch(_bookRepoProvider),
      ref.watch(_pageRepoProvider),
      ref.watch(_fsProvider),
    ),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});

final _downloadedBooksProvider = FutureProvider<List<BookEntity>>((ref) async {
  final bookRepo = ref.watch(_bookRepoProvider);
  final allBooks = await bookRepo.getAllLocal();
  return allBooks.where((b) => b.isDownloaded).toList();
});

final _storageSizeProvider = FutureProvider<String>((ref) async {
  final fs = ref.read(_fsProvider);
  final size = await fs.getTotalStorageSize();
  return _formatBytes(size);
});

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

class DownloadsScreen extends ConsumerStatefulWidget {
  const DownloadsScreen({super.key});

  @override
  ConsumerState<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends ConsumerState<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final storageAsync = ref.watch(_storageSizeProvider);
    final downloadsAsync = ref.watch(_downloadedBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
      ),
      body: Column(
        children: [
          // Storage usage card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Storage Usage',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  storageAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (_, __) => const Text('Error loading storage info'),
                    data: (size) => Text(
                      'Total: $size',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () => _showClearCacheDialog(context),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Clear All Cache'),
                  ),
                ],
              ),
            ),
          ),
          // Downloaded books list
          Expanded(
            child: downloadsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (books) {
                if (books.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.download_done, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No downloaded books'),
                        const SizedBox(height: 8),
                        Text(
                          'Download books for offline reading',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return _DownloadedBookTile(book: book);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showClearCacheDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Cache'),
        content: const Text(
          'This will delete all cached pages. Downloaded books will need to be re-downloaded. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final fs = ref.read(_fsProvider);
      final dir = await fs.booksDir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        await dir.create(recursive: true);
      }
      
      // Mark all books as not downloaded
      final bookRepo = ref.read(_bookRepoProvider);
      final allBooks = await bookRepo.getAllLocal();
      for (final book in allBooks) {
        await bookRepo.markDownloaded(book.komgaId, false);
      }
      
      if (mounted) {
        ref.invalidate(_downloadedBooksProvider);
        ref.invalidate(_storageSizeProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared')),
        );
      }
    }
  }
}

class _DownloadedBookTile extends ConsumerWidget {
  final BookEntity book;

  const _DownloadedBookTile({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fs = ref.read(_fsProvider);
    final dl = ref.read(_dlProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(book.title),
        subtitle: FutureBuilder<int>(
          future: fs.getBookStorageSize(book.komgaId),
          builder: (context, snap) {
            final size = snap.data ?? 0;
            return Text('${_formatBytes(size)} • ${book.pageCount} pages');
          },
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Delete Cache'),
              onTap: () async {
                await dl.deleteBookCache(book.komgaId);
                if (context.mounted) {
                  ref.invalidate(_downloadedBooksProvider);
                  ref.invalidate(_storageSizeProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted cache for ${book.title}')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

