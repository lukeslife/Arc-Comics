import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/series_repo.dart';
import '../../data/repos/book_repo.dart';
import '../../data/repos/page_repo.dart';
import '../../data/storage/file_store.dart';
import '../../domain/models/series.dart';
import '../../domain/services/download_service.dart';

final _clientProvider = Provider((_) => KomgaClient());
final _seriesRepoProvider = Provider((ref) => SeriesRepo(ref.watch(_clientProvider)));
final _bookRepoProvider = Provider((ref) => BookRepo(ref.watch(_clientProvider)));
final _pageRepoProvider = Provider((_) => PageRepo());
final _fsProvider = Provider((_) => FileStore());
final _dlProvider = Provider((ref) => DownloadService(
  ref.watch(_clientProvider),
  ref.watch(_bookRepoProvider),
  ref.watch(_pageRepoProvider),
  ref.watch(_fsProvider),
));

final _seriesProvider = FutureProvider<List<SeriesEntity>>((ref) async {
  final repo = ref.watch(_seriesRepoProvider);
  await repo.refreshFirstPage();
  return repo.allLocal();
});

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(_seriesProvider);
    final booksRepo = ref.watch(_bookRepoProvider);
    final dl = ref.watch(_dlProvider);

    return Scaffold(
      appBar: AppBar(
  title: const Text('Library'),
  actions: [
    IconButton(
      icon: const Icon(Icons.settings),
      onPressed: () => context.push('/settings'),
    ),
  ],
),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (series) {
          if (series.isEmpty) return const Center(child: Text('No series found.'));
          return ListView.builder(
            itemCount: series.length,
            itemBuilder: (_, i) {
              final s = series[i];
              return ListTile(
                leading: const Icon(Icons.collections_bookmark),
                title: Text(s.title),
                subtitle: Text('Komga ID: ${s.komgaId}'),
                onTap: () => context.push('/series/${s.komgaId}'),
              );
            },
          );
        },
      ),
    );
  }
}
