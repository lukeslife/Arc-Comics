import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/api/komga_client.dart';
import '../../../data/repos/series_repo.dart';
import '../../../domain/models/series.dart';

final _clientProvider = FutureProvider<KomgaClient>((_) => KomgaClient.create());
final _seriesRepoProvider = Provider((ref) {
  final clientAsync = ref.watch(_clientProvider);
  return clientAsync.when(
    data: (client) => SeriesRepo(client),
    loading: () => throw Exception('Client not ready'),
    error: (_, __) => throw Exception('Client error'),
  );
});

final _recentlyAddedProvider = FutureProvider<List<SeriesEntity>>((ref) async {
  final repo = ref.watch(_seriesRepoProvider);
  final all = await repo.allLocal();
  // Sort by updatedAt descending
  all.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  return all.take(20).toList();
});

class RecentlyAddedModule extends ConsumerWidget {
  const RecentlyAddedModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_recentlyAddedProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (series) {
        if (series.isEmpty) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recently Added',
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
                itemCount: series.length,
                itemBuilder: (context, index) {
                  final s = series[index];
                  return _RecentlyAddedCard(series: s);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecentlyAddedCard extends StatelessWidget {
  final SeriesEntity series;

  const _RecentlyAddedCard({required this.series});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push('/series/${series.komgaId}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: series.thumbnailUrl != null && series.thumbnailUrl!.isNotEmpty
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
                            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.collections_bookmark, size: 48, color: Colors.grey),
                        ),
                      ),
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
                    const SizedBox(height: 4),
                    Text(
                      '${series.booksCount} ${series.booksCount == 1 ? 'book' : 'books'}',
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

