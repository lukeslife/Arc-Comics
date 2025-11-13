import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/series_repo.dart';
import '../../data/repos/book_repo.dart';
import '../../data/repos/page_repo.dart';
import '../../data/storage/file_store.dart';
import '../../domain/services/download_service.dart' as downloads;
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
final _pageRepoProvider = Provider((_) => PageRepo());
final _fsProvider = Provider((_) => FileStore());

final _dlProvider = Provider<downloads.DownloadService>((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => downloads.DownloadService(
      client,
      ref.watch(_bookRepoProvider),
      ref.watch(_pageRepoProvider),
      ref.watch(_fsProvider),
    ),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});

final _seriesDetailProvider =
    FutureProvider.family<SeriesEntity?, String>((ref, seriesId) async {
  final repo = ref.watch(_seriesRepoProvider);
  return await repo.refreshSeries(seriesId);
});

final _seriesBooksProvider =
    FutureProvider.family<List<BookEntity>, String>((ref, seriesId) async {
  final repo = ref.watch(_bookRepoProvider);
  return await repo.refreshForSeries(seriesId);
});

// Global map to track download progress for all books
final StateProvider<Map<String, downloads.DownloadProgress>>
    _allDownloadProgressProvider =
    StateProvider<Map<String, downloads.DownloadProgress>>((ref) {
  final dl = ref.read(_dlProvider);

  dl.onProgress = (bookId, progress) {
    ref.read(_allDownloadProgressProvider.notifier).update((state) {
      final newState =
          Map<String, downloads.DownloadProgress>.from(state);
      newState[bookId] = progress;
      return newState;
    });
  };

  return <String, downloads.DownloadProgress>{};
});

// Provider to track download progress for a specific book
final _downloadProgressProvider =
    Provider.family<downloads.DownloadProgress?, String>((ref, bookId) {
  final allProgress = ref.watch(_allDownloadProgressProvider);
  return allProgress[bookId] ?? ref.read(_dlProvider).getProgress(bookId);
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
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final book = books[index];
                          return _BookCoverCard(book: book);
                        },
                        childCount: books.length,
                      ),
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

class _BookCoverCard extends ConsumerStatefulWidget {
  final BookEntity book;

  const _BookCoverCard({required this.book});

  @override
  ConsumerState<_BookCoverCard> createState() => _BookCoverCardState();
}

class _BookCoverCardState extends ConsumerState<_BookCoverCard> {
  @override
  void initState() {
    super.initState();
    // Initialize download progress provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Access the provider to set up the listener
      ref.read(_downloadProgressProvider(widget.book.komgaId));
    });
  }

  double get _readingProgress {
    if (widget.book.pageCount == 0) return 0;
    return (widget.book.readPageCount / widget.book.pageCount).clamp(0.0, 1.0);
  }

  bool get _isInProgress => widget.book.currentPageIndex > 0 && widget.book.currentPageIndex < widget.book.pageCount - 1;
  bool get _isCompleted => widget.book.readPageCount >= widget.book.pageCount && widget.book.pageCount > 0;

  @override
  Widget build(BuildContext context) {
    final mt = (widget.book.mediaType ?? '').toLowerCase();
    final isEpub = mt.contains('epub');
    final isPdf = mt.contains('pdf');
    final isImageComic = !isEpub && !isPdf;
    
    final downloadProgress = ref.watch(_downloadProgressProvider(widget.book.komgaId));
    final isDownloading = downloadProgress?.isActive ?? false;
    final downloadPercent = downloadProgress?.progress ?? 0.0;

    return GestureDetector(
      onTap: isImageComic && widget.book.pageCount > 0
          ? () => context.push(
                '/reader/${widget.book.komgaId}?count=${widget.book.pageCount}&title=${Uri.encodeComponent(widget.book.title)}',
              )
          : null,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image
            _BookCoverImage(book: widget.book),
            
            // Gradient overlay for text readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      widget.book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Page count or status
                    Text(
                      widget.book.pageCount > 0 ? '${widget.book.pageCount} pages' : 'No pages',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Top-right status indicators
            Positioned(
              top: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Download status
                  if (widget.book.isDownloaded)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.download_done,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  else if (isDownloading)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: downloadPercent,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    )
                  else if (isImageComic && widget.book.pageCount > 0)
                    IconButton(
                      icon: const Icon(Icons.download, size: 20),
                      color: Colors.white,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () async {
                        final dl = ref.read(_dlProvider);
                        await dl.downloadBook(widget.book.komgaId, widget.book.pageCount);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Downloading ${widget.book.title}...')),
                          );
                        }
                      },
                    ),
                  
                  const SizedBox(height: 4),
                  
                  // Reading progress indicator
                  if (_isCompleted)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  else if (_isInProgress)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
            
            // Download progress bar (when downloading)
            if (isDownloading)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: downloadPercent,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.blue.withOpacity(0.8),
                  ),
                  minHeight: 3,
                ),
              ),
            
            // Reading progress bar (when reading)
            if ((_isInProgress || _isCompleted) && !isDownloading)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _readingProgress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _isCompleted ? Colors.green : Colors.orange,
                  ),
                  minHeight: 3,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BookCoverImage extends ConsumerWidget {
  final BookEntity book;

  const _BookCoverImage({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(_clientProvider);
    
    return clientAsync.when(
      loading: () => Container(
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.error, color: Colors.grey)),
      ),
      data: (client) => CachedNetworkImage(
        imageUrl: '${client.baseUrl}/api/v1/books/${book.komgaId}/thumbnail',
        httpHeaders: client.getAuthHeaders(),
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

