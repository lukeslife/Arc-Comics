import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arc_comics/data/api/komga_client.dart';
import 'package:arc_comics/data/storage/file_store.dart';
import 'package:arc_comics/data/repos/page_repo.dart';
import 'dart:io';

final _client = Provider((_) => KomgaClient());
final _fs = Provider((_) => FileStore());
final _pagesRepo = Provider((_) => PageRepo());

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookKomgaId;
  final int? initialPageCount; // may be null/0; we'll fetch real count

  const ReaderScreen({
    super.key,
    required this.bookKomgaId,
    this.initialPageCount,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  int? _pageCount;

  @override
  void initState() {
    super.initState();
    _ensurePageCount();
  }

  Future<void> _ensurePageCount() async {
    if ((widget.initialPageCount ?? 0) > 0) {
      setState(() => _pageCount = widget.initialPageCount);
      return;
    }
    final api = ref.read(_client);
    final pages = await api.listPages(widget.bookKomgaId);
    setState(() => _pageCount = pages.length);
  }

  Future<ImageProvider> _loadPage(int index) async {
    final store = ref.read(_fs);
    final repo = ref.read(_pagesRepo);
    final api = ref.read(_client);

    // 1) Disk first
    final f = await store.pageFile(widget.bookKomgaId, index);
    if (await f.exists()) {
      return FileImage(f);
    }

    // 2) Network then cache
    final oneBased = index + 1;
    final res = await api.fetchPageBytes(widget.bookKomgaId, oneBased);
    final bytes = Uint8List.fromList(res.data ?? const []);
    await f.writeAsBytes(bytes, flush: true);
    await repo.setLocalPath(widget.bookKomgaId, index, f.path);
    return MemoryImage(bytes);
  }

  @override
Widget build(BuildContext context) {
  final count = _pageCount;
  return Scaffold(
    appBar: AppBar(title: const Text('Reader')),
    body: () {
      if (count == null) return const Center(child: CircularProgressIndicator());
      if (count == 0) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('This book has no pages.'),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: _ensurePageCount,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      return PageView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return FutureBuilder<ImageProvider>(
            future: _loadPage(index),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              return InteractiveViewer(
                minScale: 1, maxScale: 5,
                child: Image(image: snap.data!, fit: BoxFit.contain, gaplessPlayback: true),
              );
            },
          );
        },
      );
    }(),
  );
}

}
