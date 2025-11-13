import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/book_repo.dart';
import '../../domain/models/book.dart';

final _clientProvider = FutureProvider<KomgaClient>((_) => KomgaClient.create());
final _booksRepo = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => BookRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});

class SeriesBooksScreen extends ConsumerWidget {
  final String seriesKomgaId;
  const SeriesBooksScreen({super.key, required this.seriesKomgaId});

  Future<int> _resolvePageCount(WidgetRef ref, String bookId, int hinted) async {
    if (hinted > 0) return hinted;
    final client = await ref.read(_clientProvider.future);
    final pages = await client.listPages(bookId);
    return pages.length;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: FutureBuilder<List<BookEntity>>(
        future: ref.read(_booksRepo).refreshForSeries(seriesKomgaId),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final books = snap.data!;
          if (books.isEmpty) return const Center(child: Text('No books in this series.'));
          return ListView.separated(
            itemCount: books.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final b = books[i];
              return FutureBuilder<int>(
  future: _resolvePageCount(ref, b.komgaId, b.pageCount),
  builder: (context, psnap) {
    final count = psnap.data ?? b.pageCount;
    final mt = (b.mediaType ?? '').toLowerCase();
    final isEpub = mt.contains('epub');
    final isPdf  = mt.contains('pdf');
    final isImageComic = !isEpub && !isPdf; // good enough for now

    final subtitle = isEpub
        ? 'eBook (EPUB)'
        : isPdf
          ? 'Document (PDF)'
          : (count > 0 ? 'Pages: $count' : 'No pages');

    return ListTile(
      leading: Icon(isEpub || isPdf ? Icons.menu_book : Icons.menu_book_outlined),
      title: Text(b.title),
      subtitle: Text(subtitle),
      enabled: isImageComic && count > 0,
      onTap: (!isImageComic || count == 0)
    ? null
    : () => context.push(
          '/reader/${b.komgaId}?count=$count&title=${Uri.encodeComponent(b.title)}',
      ),
    );
  },
);
            },
          );
        },
      ),
    );
  }
}
