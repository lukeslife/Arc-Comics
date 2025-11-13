import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:arc_comics/data/api/komga_client.dart';
import 'package:arc_comics/data/repos/page_repo.dart';
import 'package:arc_comics/data/storage/file_store.dart';

import '../settings/settings_controller.dart';
import 'package:arc_comics/domain/models/settings.dart';

final _client = Provider((_) => KomgaClient());
final _fs = Provider((_) => FileStore());
final _pagesRepo = Provider((_) => PageRepo());

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookKomgaId;
  final int? initialPageCount;
  final String title;

  const ReaderScreen({
    super.key,
    required this.bookKomgaId,
    this.initialPageCount,
    this.title = 'Reader',
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  int? _pageCount;
  late final PageController _pc;
  int _index = 0;

  // user settings (loaded once, kept in memory)
  SettingsEntity? _settings;

  // tiny in-memory cache of futures to avoid duplicate loads
  final Map<int, Future<ImageProvider>> _pending = {};

  @override
  void initState() {
    super.initState();
    _pc = PageController();
    _ensurePageCount();
    _loadSettings();
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final s = await ref.read(settingsProvider.future);
    if (mounted) setState(() => _settings = s);
  }

  Future<void> _ensurePageCount() async {
    if ((widget.initialPageCount ?? 0) > 0) {
      setState(() => _pageCount = widget.initialPageCount);
      return;
    }
    final pages = await ref.read(_client).listPages(widget.bookKomgaId);
    if (mounted) setState(() => _pageCount = pages.length);
  }

  BoxFit _fitFor(int mode) {
    switch (mode) {
      case 1:
        return BoxFit.fitWidth;
      case 2:
        return BoxFit.fitHeight;
      default:
        return BoxFit.contain;
    }
  }

  Future<ImageProvider> _loadPage(int index) {
    // return cached future if present
    final hit = _pending[index];
    if (hit != null) return hit;

    final future = () async {
      final store = ref.read(_fs);
      final repo = ref.read(_pagesRepo);
      final api = ref.read(_client);

      // 1) Disk first
      final f = await store.pageFile(widget.bookKomgaId, index);
      if (await f.exists()) return FileImage(f) as ImageProvider;

      // 2) Network (respect Wi-Fi-only setting), then cache
      if (_settings?.wifiOnlyStreaming == true) {
        final status = await Connectivity().checkConnectivity();
        final onWifi = status.contains(ConnectivityResult.wifi);
        if (!onWifi) {
          throw Exception('Streaming disabled on cellular');
        }
      }

      final oneBased = index + 1;
      final res = await api.fetchPageBytes(widget.bookKomgaId, oneBased);
      final bytes = Uint8List.fromList(res.data ?? const []);
      await f.writeAsBytes(bytes, flush: true);
      await repo.setLocalPath(widget.bookKomgaId, index, f.path);
      return MemoryImage(bytes) as ImageProvider;
    }();

    _pending[index] = future;
    return future;
  }

  void _prefetchNext(int current) {
    if (_settings?.prefetchNextPage != true) return;
    final total = _pageCount ?? 0;
    final next = current + 1;
    if (next < total && !_pending.containsKey(next)) {
      _loadPage(next); // fire-and-forget
    }
  }

  void _goPrev() {
    if (_index > 0) {
      _pc.previousPage(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  void _goNext() {
    final total = _pageCount ?? 0;
    if (_index + 1 < total) {
      _pc.nextPage(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _pageCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, overflow: TextOverflow.ellipsis),
        centerTitle: true,
        actions: [
          // quick fit switcher
          PopupMenuButton<int>(
            onSelected: (v) async {
  await ref
      .read(settingsProvider.notifier)
      .updateSettings((x) => x.fitMode = v);
  await _loadSettings();
  setState(() {}); // repaint with new fit
},

            itemBuilder: (_) => const [
              PopupMenuItem(value: 0, child: Text('Fit: Contain')),
              PopupMenuItem(value: 1, child: Text('Fit: Width')),
              PopupMenuItem(value: 2, child: Text('Fit: Height')),
            ],
            icon: const Icon(Icons.aspect_ratio),
          ),
          if (total != null && total > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${_index + 1}/$total',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          IconButton(onPressed: _goPrev, icon: const Icon(Icons.chevron_left)),
          IconButton(onPressed: _goNext, icon: const Icon(Icons.chevron_right)),
        ],
      ),
      body: () {
        if (total == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (total == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('This book has no pages to display.'),
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
          controller: _pc,
          itemCount: total,
          onPageChanged: (i) {
            setState(() => _index = i);
            _prefetchNext(i);
          },
          itemBuilder: (context, index) {
            return FutureBuilder<ImageProvider>(
              future: _loadPage(index),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Text('Error loading page ${index + 1}'),
                  );
                }
                if (!snap.hasData) {
                  _prefetchNext(index); // while loading, prep next
                  return const Center(child: CircularProgressIndicator());
                }

                final fit = _fitFor(_settings?.fitMode ?? 1);
                final tapZones = _settings?.tapZones ?? true;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (d) {
                    if (!tapZones) return;
                    final w = MediaQuery.of(context).size.width;
                    final x = d.localPosition.dx;
                    if (x < w * 0.33) {
                      _goPrev();
                    } else if (x > w * 0.66) {
                      _goNext();
                    }
                  },
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 5,
                    child: Image(
                      image: snap.data!,
                      fit: fit,
                      gaplessPlayback: true,
                    ),
                  ),
                );
              },
            );
          },
        );
      }(),
    );
  }
}
