import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/series_repo.dart';
import '../../data/repos/book_repo.dart';
import '../../data/repos/page_repo.dart';
import '../../data/storage/file_store.dart';
import '../../domain/models/series.dart';
import '../../domain/services/download_service.dart';

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

final _seriesProvider = FutureProvider<List<SeriesEntity>>((ref) async {
  final repo = ref.watch(_seriesRepoProvider);
  await repo.refreshFirstPage();
  return repo.allLocal();
});

final _viewModeProvider = StateProvider<bool>((ref) => false); // false = grid, true = list

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_seriesProvider);
    final viewMode = ref.watch(_viewModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(viewMode ? Icons.grid_view : Icons.list),
            onPressed: () => ref.read(_viewModeProvider.notifier).state = !viewMode,
            tooltip: viewMode ? 'Grid view' : 'List view',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_seriesProvider),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(_seriesProvider);
          await ref.read(_seriesProvider.future);
        },
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $e', style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(_seriesProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (series) {
            if (series.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.collections_bookmark, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No series found.'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(_seriesProvider),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }
            return viewMode ? _buildListView(series) : _buildGridView(series);
          },
        ),
      ),
    );
  }

  Widget _buildGridView(List<SeriesEntity> series) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final s = series[index];
        return _SeriesCard(series: s);
      },
    );
  }

  Widget _buildListView(List<SeriesEntity> series) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final s = series[index];
        return _SeriesListTile(series: s);
      },
    );
  }
}

class _SeriesCard extends StatelessWidget {
  final SeriesEntity series;

  const _SeriesCard({required this.series});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/series/${series.komgaId}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildThumbnail(),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    series.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (series.publisher != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      series.publisher!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${series.booksCount} ${series.booksCount == 1 ? 'book' : 'books'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    if (series.thumbnailUrl == null || series.thumbnailUrl!.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.collections_bookmark, size: 48, color: Colors.grey),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: series.thumbnailUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      ),
    );
  }
}

class _SeriesListTile extends StatelessWidget {
  final SeriesEntity series;

  const _SeriesListTile({required this.series});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 90,
        child: _buildThumbnail(),
      ),
      title: Text(series.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (series.publisher != null) Text(series.publisher!),
          Text('${series.booksCount} ${series.booksCount == 1 ? 'book' : 'books'}'),
        ],
      ),
      onTap: () => context.push('/series/${series.komgaId}'),
    );
  }

  Widget _buildThumbnail() {
    if (series.thumbnailUrl == null || series.thumbnailUrl!.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.collections_bookmark, size: 32, color: Colors.grey),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: series.thumbnailUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.broken_image, size: 32, color: Colors.grey),
        ),
      ),
    );
  }
}
