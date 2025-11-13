import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/series_repo.dart';
import '../../data/repos/book_repo.dart';
import '../../domain/models/series.dart';
import '../../domain/models/book.dart';

final _clientProvider = FutureProvider<KomgaClient>((_) => KomgaClient.create());
final _seriesRepoProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => SeriesRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});
final _bookRepoProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => BookRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});

final _seriesDetailProvider = FutureProvider.family<SeriesEntity?, String>((ref, seriesId) async {
  final repo = ref.watch(_seriesRepoProvider);
  return await repo.refreshSeries(seriesId);
});

final _seriesBooksProvider = FutureProvider.family<List<BookEntity>, String>((ref, seriesId) async {
  final repo = ref.watch(_bookRepoProvider);
  return await repo.refreshForSeries(seriesId);
});

class SeriesDetailScreen extends ConsumerWidget {
  final String seriesKomgaId;
  const SeriesDetailScreen({super.key, required this.seriesKomgaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(_seriesDetailProvider(seriesKomgaId));
    final booksAsync = ref.watch(_seriesBooksProvider(seriesKomgaId));

    return Scaffold(
      body: seriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(_seriesDetailProvider(seriesKomgaId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (series) {
          if (series == null) {
            return const Center(child: Text('Series not found'));
          }
          return CustomScrollView(
            slivers: [
              _SeriesHeader(series: series),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (series.publisher != null) ...[
                        Chip(
                          label: Text(series.publisher!),
                          avatar: const Icon(Icons.business, size: 18),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (series.description != null && series.description!.isNotEmpty) ...[
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          series.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        'Books',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              booksAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  )),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text('Error loading books: $e'),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(_seriesBooksProvider(seriesKomgaId)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                data: (books) {
                  if (books.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: Text('No books in this series')),
                      ),
                    );
                  }
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final book = books[index];
                        return _BookListItem(book: book);
                      },
                      childCount: books.length,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SeriesHeader extends StatelessWidget {
  final SeriesEntity series;

  const _SeriesHeader({required this.series});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(series.title),
        background: series.thumbnailUrl != null && series.thumbnailUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: series.thumbnailUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  ),
                ),
              )
            : Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.collections_bookmark, size: 64, color: Colors.grey),
                ),
              ),
      ),
    );
  }
}

class _BookListItem extends StatelessWidget {
  final BookEntity book;

  const _BookListItem({required this.book});

  double get _readingProgress {
    if (book.pageCount == 0) return 0;
    return (book.readPageCount / book.pageCount).clamp(0.0, 1.0);
  }

  bool get _isInProgress => book.currentPageIndex > 0 && book.currentPageIndex < book.pageCount - 1;
  bool get _isCompleted => book.readPageCount >= book.pageCount && book.pageCount > 0;

  @override
  Widget build(BuildContext context) {
    final mt = (book.mediaType ?? '').toLowerCase();
    final isEpub = mt.contains('epub');
    final isPdf = mt.contains('pdf');
    final isImageComic = !isEpub && !isPdf;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.menu_book),
        title: Text(book.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEpub
                ? 'eBook (EPUB)'
                : isPdf
                    ? 'Document (PDF)'
                    : (book.pageCount > 0 ? '${book.pageCount} pages' : 'No pages')),
            if (_isInProgress || _isCompleted) ...[
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: _readingProgress,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(height: 2),
              Text(
                _isCompleted
                    ? 'Completed'
                    : 'Page ${book.currentPageIndex + 1} of ${book.pageCount}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
        trailing: _isInProgress
            ? FilledButton(
                onPressed: isImageComic && book.pageCount > 0
                    ? () => context.push(
                          '/reader/${book.komgaId}?count=${book.pageCount}&title=${Uri.encodeComponent(book.title)}',
                        )
                    : null,
                child: const Text('Continue'),
              )
            : _isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green)
                : isImageComic && book.pageCount > 0
                    ? OutlinedButton(
                        onPressed: () => context.push(
                              '/reader/${book.komgaId}?count=${book.pageCount}&title=${Uri.encodeComponent(book.title)}',
                            ),
                        child: const Text('Read'),
                      )
                    : null,
        enabled: isImageComic && book.pageCount > 0,
        onTap: isImageComic && book.pageCount > 0
            ? () => context.push(
                  '/reader/${book.komgaId}?count=${book.pageCount}&title=${Uri.encodeComponent(book.title)}',
                )
            : null,
      ),
    );
  }
}

