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

final _publisherShelvesProvider = FutureProvider<Map<String, List<SeriesEntity>>>((ref) async {
  final repo = ref.watch(_seriesRepoProvider);
  final all = await repo.allLocal();
  
  // Group by publisher
  final Map<String, List<SeriesEntity>> grouped = {};
  for (final series in all) {
    final publisher = series.publisher ?? 'Unknown';
    grouped.putIfAbsent(publisher, () => []).add(series);
  }
  
  // Sort publishers by series count, take top 10
  final sortedPublishers = grouped.entries.toList()
    ..sort((a, b) => b.value.length.compareTo(a.value.length));
  
  final result = <String, List<SeriesEntity>>{};
  for (final entry in sortedPublishers.take(10)) {
    result[entry.key] = entry.value.take(10).toList(); // Limit to 10 series per publisher
  }
  
  return result;
});

class PublisherShelvesModule extends ConsumerWidget {
  const PublisherShelvesModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_publisherShelvesProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (shelves) {
        if (shelves.isEmpty) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: shelves.entries.map((entry) {
            return _PublisherShelf(
              publisher: entry.key,
              series: entry.value,
            );
          }).toList(),
        );
      },
    );
  }
}

class _PublisherShelf extends StatelessWidget {
  final String publisher;
  final List<SeriesEntity> series;

  const _PublisherShelf({
    required this.publisher,
    required this.series,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            publisher,
            style: Theme.of(context).textTheme.titleLarge,
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
              return _PublisherSeriesCard(series: s);
            },
          ),
        ),
      ],
    );
  }
}

class _PublisherSeriesCard extends StatelessWidget {
  final SeriesEntity series;

  const _PublisherSeriesCard({required this.series});

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
                child: Text(
                  series.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

