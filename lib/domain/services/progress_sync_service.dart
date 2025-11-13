import '../../data/api/komga_client.dart';
import '../../data/storage/progress_sync_queue.dart';
import 'dart:async';

/// Service to sync reading progress from queue to Komga server
class ProgressSyncService {
  final KomgaClient _client;
  Timer? _syncTimer;
  bool _isSyncing = false;

  ProgressSyncService(this._client);

  /// Start periodic sync (every 30 seconds)
  void startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _syncPending();
    });
    // Also sync immediately
    _syncPending();
  }

  /// Stop periodic sync
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  /// Sync all pending progress updates
  Future<void> _syncPending() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final pending = await ProgressSyncQueue.getPending();
      for (final sync in pending) {
        try {
          await _client.updateReadingProgress(
            sync.bookKomgaId,
            sync.pageNumber,
          );
          await ProgressSyncQueue.markSynced(sync.id);
        } catch (e) {
          // Keep in queue for next attempt
          // Could add retry limit here
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Manually trigger a sync
  Future<void> syncNow() async {
    await _syncPending();
  }

  /// Cleanup old synced entries (call periodically)
  Future<void> cleanup() async {
    await ProgressSyncQueue.cleanup(7); // Remove entries older than 7 days
  }
}

