import 'package:isar/isar.dart';
import '../api/komga_client.dart';
import '../db/isar_schemas.dart';
import '../../domain/models/book.dart';

class BookRepo {
  final KomgaClient _api;
  BookRepo(this._api);

  // Helpers to coerce dynamic JSON into sane types
  int _asInt(dynamic v, {int fallback = 0}) {
    if (v == null) return fallback;
    if (v is num) return v.toInt();
    final s = v.toString().trim();
    return int.tryParse(s) ?? fallback;
  }

  DateTime _asDate(dynamic v, {DateTime? fallback}) {
    if (v == null) return fallback ?? DateTime.now();
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString()) ?? (fallback ?? DateTime.now());
  }

  String _titleFrom(Map m) {
    final md = (m['metadata'] as Map?) ?? const {};
    return (md['title'] as String?) ??
           (m['name'] as String?) ??
           (m['title'] as String?) ??
           'Untitled';
  }

    Future<List<BookEntity>> refreshForSeries(String seriesKomgaId) async {
    final db = await AppDb.open();
    final res = await _api.listBooks(seriesKomgaId, page: 0, size: 500);

    int _pagesFrom(dynamic m) {
      final media = (m['media'] as Map?) ?? const {};
      // Komga often stores page count here
      final pc = media['pagesCount'] ?? m['pageCount'];
      return _asInt(pc);
    }

    String? _mediaType(dynamic m) {
      final media = (m['media'] as Map?) ?? const {};
      final mt = media['mediaType'];
      return mt?.toString();
    }

    final entities = res.map((m) {
      final md = (m['metadata'] as Map?) ?? const {};
      final title = _titleFrom(m);
      final number = _asInt(md['number']);
      final pageCount = _pagesFrom(m);
      final updated = _asDate(m['lastModified'], fallback: _asDate(m['created']));
      final mt = _mediaType(m);

      return BookEntity(
        komgaId: m['id'] as String,
        seriesKomgaId: seriesKomgaId,
        title: title,
        number: number,
        pageCount: pageCount,
        updatedAt: updated,
        mediaType: mt,
      );
    }).toList();

    await db.writeTxn(() async {
      for (final b in entities) {
        final existing = await db.bookEntitys.filter().komgaIdEqualTo(b.komgaId).findFirst();
        if (existing != null) b.id = existing.id;
        await db.bookEntitys.put(b);
      }
    });

    return db.bookEntitys
        .filter()
        .seriesKomgaIdEqualTo(seriesKomgaId)
        .sortByNumber()
        .findAll();
  }


  Future<List<BookEntity>> bySeriesLocal(String seriesKomgaId) async {
    final db = await AppDb.open();
    return db.bookEntitys
        .filter()
        .seriesKomgaIdEqualTo(seriesKomgaId)
        .sortByNumber()
        .findAll();
  }

  Future<void> markDownloaded(String bookKomgaId, bool v) async {
    final db = await AppDb.open();
    final existing =
        await db.bookEntitys.filter().komgaIdEqualTo(bookKomgaId).findFirst();
    if (existing != null) {
      await db.writeTxn(() async {
        existing.isDownloaded = v;
        await db.bookEntitys.put(existing);
      });
    }
  }
}
