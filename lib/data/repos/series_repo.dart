import 'package:isar/isar.dart';
import '../api/komga_client.dart';
import '../db/isar_schemas.dart';
import '../../domain/models/series.dart';

class SeriesRepo {
  final KomgaClient _api;
  SeriesRepo(this._api);

  Future<List<SeriesEntity>> refreshFirstPage() async {
    final db = await AppDb.open();
    final raw = await _api.listSeries(page: 0, size: 50);
    final entities = raw.map((m) => SeriesEntity(
      komgaId: m['id'] as String,
      title: m['metadata']['title'] as String? ?? m['name'] as String? ?? 'Untitled',
      thumbnailUrl: m['thumbnailUrl'] as String?,
      booksCount: (m['booksCount'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(m['lastModified'] ?? m['created']) ?? DateTime.now(),
    )).toList();

    await db.writeTxn(() async {
      // Simple upsert by komgaId
      for (final e in entities) {
        final existing = await db.seriesEntitys.filter().komgaIdEqualTo(e.komgaId).findFirst();
        if (existing != null) {
          e.id = existing.id;
        }
        await db.seriesEntitys.put(e);
      }
    });
    return db.seriesEntitys.where().findAll();
  }

  Future<List<SeriesEntity>> allLocal() async {
    final db = await AppDb.open();
    return db.seriesEntitys.where().sortByTitle().findAll();
  }
}
