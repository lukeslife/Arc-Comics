import 'package:isar/isar.dart';
import '../db/isar_schemas.dart';
part 'progress_sync_queue.g.dart';

/// Entity to track pending reading progress syncs
@collection
class ProgressSyncEntity {
  Id id = Isar.autoIncrement;
  final String bookKomgaId;
  final int pageNumber; // 1-based page number for Komga
  final DateTime queuedAt;
  bool synced;

  ProgressSyncEntity({
    this.id = Isar.autoIncrement,
    required this.bookKomgaId,
    required this.pageNumber,
    required this.queuedAt,
    this.synced = false,
  });
}

class ProgressSyncQueue {
  /// Add a progress update to the sync queue
  static Future<void> enqueue(String bookKomgaId, int pageNumber) async {
    final db = await AppDb.open();
    await db.writeTxn(() async {
      // Remove any existing pending syncs for this book
      final existing = await db.progressSyncEntitys
          .filter()
          .bookKomgaIdEqualTo(bookKomgaId)
          .and()
          .syncedEqualTo(false)
          .findAll();
      for (final e in existing) {
        await db.progressSyncEntitys.delete(e.id);
      }
      
      // Add new sync entry
      await db.progressSyncEntitys.put(ProgressSyncEntity(
        bookKomgaId: bookKomgaId,
        pageNumber: pageNumber,
        queuedAt: DateTime.now(),
      ));
    });
  }

  /// Get all pending syncs
  static Future<List<ProgressSyncEntity>> getPending() async {
    final db = await AppDb.open();
    return await db.progressSyncEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByQueuedAt()
        .findAll();
  }

  /// Mark a sync as completed
  static Future<void> markSynced(Id id) async {
    final db = await AppDb.open();
    await db.writeTxn(() async {
      final entity = await db.progressSyncEntitys.get(id);
      if (entity != null) {
        entity.synced = true;
        await db.progressSyncEntitys.put(entity);
      }
    });
  }

  /// Remove old synced entries (cleanup)
  static Future<void> cleanup(int daysOld) async {
    final db = await AppDb.open();
    final cutoff = DateTime.now().subtract(Duration(days: daysOld));
    await db.writeTxn(() async {
      final old = await db.progressSyncEntitys
          .filter()
          .syncedEqualTo(true)
          .and()
          .queuedAtLessThan(cutoff)
          .findAll();
      for (final e in old) {
        await db.progressSyncEntitys.delete(e.id);
      }
    });
  }
}

