import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/api/komga_client.dart';
import '../../../data/repos/book_repo.dart';
import '../../../data/repos/series_repo.dart';
import '../../../domain/models/book.dart';
import '../../../domain/models/series.dart';

final _clientProvider = FutureProvider<KomgaClient>((_) => KomgaClient.create());
final _bookRepoProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => BookRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});
final _seriesRepoProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => SeriesRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});

final _continueReadingProvider = FutureProvider<List<BookEntity>>((ref) async {
  final bookRepo = ref.watch(_bookRepoProvider);
  final allBooks = await bookRepo.getAllLocal();
  // Filter for books in progress
  final inProgress = allBooks.where((b) => 
    b.currentPageIndex > 0 && 
    b.currentPageIndex < b.pageCount - 1 &&
    b.pageCount > 0
  ).toList();
  // Sort by lastOpenedAt descending
  inProgress.sort((a, b) {
    final aTime = a.lastOpenedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bTime = b.lastOpenedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bTime.compareTo(aTime);
  });
  return inProgress.take(20).toList();
});

class ContinueReadingModule extends ConsumerWidget {
  const ContinueReadingModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_continueReadingProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (books) {
        if (books.isEmpty) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continue Reading',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton(
                    onPressed: () => context.push('/library'),
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return _ContinueReadingCard(book: book);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ContinueReadingCard extends ConsumerWidget {
  final BookEntity book;

  const _ContinueReadingCard({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = book.pageCount > 0 
        ? (book.currentPageIndex + 1) / book.pageCount 
        : 0.0;

    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(
            '/reader/${book.komgaId}?count=${book.pageCount}&title=${Uri.encodeComponent(book.title)}',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.menu_book, size: 48, color: Colors.grey),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Page ${book.currentPageIndex + 1} of ${book.pageCount}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

