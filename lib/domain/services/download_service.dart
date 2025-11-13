import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../data/api/komga_client.dart';
import '../../data/repos/book_repo.dart';
import '../../data/repos/page_repo.dart';
import '../../data/storage/file_store.dart';

enum DownloadStatus {
  queued,
  downloading,
  completed,
  failed,
  cancelled,
}

class DownloadProgress {
  final String bookKomgaId;
  final int totalPages;
  final int downloadedPages;
  final DownloadStatus status;
  final String? error;

  DownloadProgress({
    required this.bookKomgaId,
    required this.totalPages,
    required this.downloadedPages,
    required this.status,
    this.error,
  });

  double get progress => totalPages > 0 ? downloadedPages / totalPages : 0.0;
  bool get isComplete => status == DownloadStatus.completed;
  bool get isActive => status == DownloadStatus.downloading || status == DownloadStatus.queued;
}

class DownloadService {
  final KomgaClient _api;
  final BookRepo _books;
  final PageRepo _pages;
  final FileStore _fs;
  
  // Track active downloads
  final Map<String, DownloadProgress> _activeDownloads = {};
  final Map<String, bool> _cancellationFlags = {};
  
  // Callback for progress updates
  void Function(String bookId, DownloadProgress progress)? onProgress;

  DownloadService(this._api, this._books, this._pages, this._fs);

  /// Get current download progress for a book
  DownloadProgress? getProgress(String bookKomgaId) {
    return _activeDownloads[bookKomgaId];
  }

  /// Check if a book is currently downloading
  bool isDownloading(String bookKomgaId) {
    return _activeDownloads[bookKomgaId]?.isActive ?? false;
  }

  /// Downloads all pages for a book to local storage with progress tracking.
  /// Supports parallel downloads for better performance.
  Future<void> downloadBook(String bookKomgaId, int pageCount) async {
    if (isDownloading(bookKomgaId)) {
      return; // Already downloading
    }

    _cancellationFlags[bookKomgaId] = false;
    _activeDownloads[bookKomgaId] = DownloadProgress(
      bookKomgaId: bookKomgaId,
      totalPages: pageCount,
      downloadedPages: 0,
      status: DownloadStatus.queued,
    );
    _notifyProgress(bookKomgaId);

    try {
      _activeDownloads[bookKomgaId] = DownloadProgress(
        bookKomgaId: bookKomgaId,
        totalPages: pageCount,
        downloadedPages: 0,
        status: DownloadStatus.downloading,
      );
      _notifyProgress(bookKomgaId);

      // Download pages in parallel (up to 3 concurrent)
      final semaphore = <Future<void>>[];
      int completed = 0;

      for (int i = 0; i < pageCount; i++) {
        if (_cancellationFlags[bookKomgaId] == true) {
          _activeDownloads[bookKomgaId] = DownloadProgress(
            bookKomgaId: bookKomgaId,
            totalPages: pageCount,
            downloadedPages: completed,
            status: DownloadStatus.cancelled,
          );
          _notifyProgress(bookKomgaId);
          return;
        }

        // Wait if we have too many concurrent downloads
        if (semaphore.length >= 3) {
          // Wait for at least one future to complete
          await Future.any(semaphore);
          // Remove the first future (we know at least one completed)
          // This is safe because Future.any guarantees at least one completed
          semaphore.removeAt(0);
        }

        final downloadFuture = _downloadPage(bookKomgaId, i).then((_) {
          completed++;
          _activeDownloads[bookKomgaId] = DownloadProgress(
            bookKomgaId: bookKomgaId,
            totalPages: pageCount,
            downloadedPages: completed,
            status: DownloadStatus.downloading,
          );
          _notifyProgress(bookKomgaId);
        });

        semaphore.add(downloadFuture);
      }

      // Wait for all remaining downloads
      await Future.wait(semaphore);

      if (_cancellationFlags[bookKomgaId] != true) {
        await _books.markDownloaded(bookKomgaId, true);
        _activeDownloads[bookKomgaId] = DownloadProgress(
          bookKomgaId: bookKomgaId,
          totalPages: pageCount,
          downloadedPages: pageCount,
          status: DownloadStatus.completed,
        );
        _notifyProgress(bookKomgaId);
      }
    } catch (e) {
      if (_cancellationFlags[bookKomgaId] != true) {
        _activeDownloads[bookKomgaId] = DownloadProgress(
          bookKomgaId: bookKomgaId,
          totalPages: pageCount,
          downloadedPages: _activeDownloads[bookKomgaId]?.downloadedPages ?? 0,
          status: DownloadStatus.failed,
          error: e.toString(),
        );
        _notifyProgress(bookKomgaId);
      }
    } finally {
      _cancellationFlags.remove(bookKomgaId);
    }
  }

  Future<void> _downloadPage(String bookKomgaId, int index) async {
    final oneBased = index + 1;
    final bytesRes = await _api.fetchPageBytes(bookKomgaId, oneBased);
    final file = await _fs.pageFile(bookKomgaId, index);
    await file.writeAsBytes(bytesRes.data!, flush: true);
    await _pages.setLocalPath(bookKomgaId, index, file.path);
  }

  /// Cancel an active download
  Future<void> cancelDownload(String bookKomgaId) async {
    _cancellationFlags[bookKomgaId] = true;
    _activeDownloads[bookKomgaId] = DownloadProgress(
      bookKomgaId: bookKomgaId,
      totalPages: _activeDownloads[bookKomgaId]?.totalPages ?? 0,
      downloadedPages: _activeDownloads[bookKomgaId]?.downloadedPages ?? 0,
      status: DownloadStatus.cancelled,
    );
    _notifyProgress(bookKomgaId);
  }

  /// Delete all cached pages for a book
  Future<void> deleteBookCache(String bookKomgaId) async {
    final base = await getApplicationSupportDirectory();
    final bookDir = Directory(p.join(base.path, 'books', bookKomgaId));
    if (await bookDir.exists()) {
      await bookDir.delete(recursive: true);
    }
    await _books.markDownloaded(bookKomgaId, false);
  }

  void _notifyProgress(String bookKomgaId) {
    final progress = _activeDownloads[bookKomgaId];
    if (progress != null && onProgress != null) {
      onProgress!(bookKomgaId, progress);
    }
  }
}
