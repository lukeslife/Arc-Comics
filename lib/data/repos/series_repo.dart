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
    final entities = raw.map((m) {
      final metadata = (m['metadata'] as Map?) ?? {};
      final title = metadata['title'] as String? ?? m['name'] as String? ?? 'Untitled';
      final publisher = metadata['publisher'] as String?;
      final description = metadata['summary'] as String? ?? metadata['description'] as String?;
      final ageRating = metadata['ageRating'] as String?;
      final releaseDateStr = metadata['releaseDate'] as String?;
      final releaseDate = releaseDateStr != null ? DateTime.tryParse(releaseDateStr) : null;
      
      return SeriesEntity(
        komgaId: m['id'] as String,
        title: title,
        thumbnailUrl: m['thumbnailUrl'] as String?,
        booksCount: (m['booksCount'] as num?)?.toInt() ?? 0,
        updatedAt: DateTime.tryParse(m['lastModified'] ?? m['created']) ?? DateTime.now(),
        publisher: publisher,
        description: description,
        ageRating: ageRating,
        releaseDate: releaseDate,
      );
    }).toList();

    await db.writeTxn(() async {
      // Simple upsert by komgaId, preserve lastOpenedAt
      for (final e in entities) {
        final existing = await db.seriesEntitys.filter().komgaIdEqualTo(e.komgaId).findFirst();
        if (existing != null) {
          e.id = existing.id;
          e.lastOpenedAt = existing.lastOpenedAt;
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

  /// Refresh a single series with full metadata
  Future<SeriesEntity?> refreshSeries(String seriesKomgaId) async {
    final db = await AppDb.open();
    try {
      final raw = await _api.getSeries(seriesKomgaId);
      final metadata = (raw['metadata'] as Map?) ?? {};
      final title = metadata['title'] as String? ?? raw['name'] as String? ?? 'Untitled';
      final publisher = metadata['publisher'] as String?;
      final description = metadata['summary'] as String? ?? metadata['description'] as String?;
      final ageRating = metadata['ageRating'] as String?;
      final releaseDateStr = metadata['releaseDate'] as String?;
      final releaseDate = releaseDateStr != null ? DateTime.tryParse(releaseDateStr) : null;
      
      await db.writeTxn(() async {
        final existing = await db.seriesEntitys.filter().komgaIdEqualTo(seriesKomgaId).findFirst();
        
        final entity = SeriesEntity(
          komgaId: seriesKomgaId,
          title: title,
          thumbnailUrl: raw['thumbnailUrl'] as String?,
          booksCount: (raw['booksCount'] as num?)?.toInt() ?? 0,
          updatedAt: DateTime.tryParse(raw['lastModified'] ?? raw['created']) ?? DateTime.now(),
          publisher: publisher,
          description: description,
          ageRating: ageRating,
          releaseDate: releaseDate,
          lastOpenedAt: existing?.lastOpenedAt,
        );
        
        if (existing != null) {
          entity.id = existing.id;
        }
        await db.seriesEntitys.put(entity);
      });
      
      return await db.seriesEntitys.filter().komgaIdEqualTo(seriesKomgaId).findFirst();
    } catch (e) {
      return null;
    }
  }

  Future<SeriesEntity?> getByKomgaId(String seriesKomgaId) async {
    final db = await AppDb.open();
    return await db.seriesEntitys.filter().komgaIdEqualTo(seriesKomgaId).findFirst();
  }
}
