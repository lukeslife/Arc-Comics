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

final _searchQueryProvider = StateProvider<String>((ref) => '');

final _searchResultsProvider = FutureProvider<List<SeriesEntity>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  if (query.isEmpty) return [];
  
  final repo = ref.watch(_seriesRepoProvider);
  final all = await repo.allLocal();
  
  // Simple local search - filter by title and publisher
  final lowerQuery = query.toLowerCase();
  return all.where((s) {
    final titleMatch = s.title.toLowerCase().contains(lowerQuery);
    final publisherMatch = s.publisher?.toLowerCase().contains(lowerQuery) ?? false;
    return titleMatch || publisherMatch;
  }).toList();
});

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(_searchQueryProvider);
    final resultsAsync = ref.watch(_searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search series...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => ref.read(_searchQueryProvider.notifier).state = '',
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.read(_searchQueryProvider.notifier).state = value;
              },
            ),
          ),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (results) {
          if (query.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Search for series'),
                  const SizedBox(height: 8),
                  Text(
                    'Search by title or publisher',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No results for "$query"'),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final series = results[index];
              return _SearchResultTile(series: series);
            },
          );
        },
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final SeriesEntity series;

  const _SearchResultTile({required this.series});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 60,
          height: 90,
          child: series.thumbnailUrl != null && series.thumbnailUrl!.isNotEmpty
              ? CachedNetworkImage(
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
                )
              : Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.collections_bookmark, size: 32, color: Colors.grey),
                  ),
                ),
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
      ),
    );
  }
}

