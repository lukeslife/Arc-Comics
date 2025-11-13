import 'package:isar/isar.dart';
import '../db/isar_schemas.dart';
import '../../domain/models/page.dart';

class PageRepo {
  Future<void> upsertPages(List<PageEntity> pages) async {
    final db = await AppDb.open();
    await db.writeTxn(() async {
      for (final p in pages) {
        final existing = await db.pageEntitys
            .filter()
            .bookKomgaIdEqualTo(p.bookKomgaId)
            .and()
            .indexEqualTo(p.index)
            .findFirst();
        if (existing != null) p.id = existing.id;
        await db.pageEntitys.put(p);
      }
    });
  }

  Future<List<PageEntity>> forBook(String bookKomgaId) async {
    final db = await AppDb.open();
    return db.pageEntitys
        .filter()
        .bookKomgaIdEqualTo(bookKomgaId)
        .sortByIndex()
        .findAll();
  }

  Future<void> setLocalPath(String bookKomgaId, int index, String path,
      {int? w, int? h}) async {
    final db = await AppDb.open();
    final page = await db.pageEntitys
        .filter()
        .bookKomgaIdEqualTo(bookKomgaId)
        .and()
        .indexEqualTo(index)
        .findFirst();
    await db.writeTxn(() async {
      if (page != null) {
        page.filePath = path;
        if (w != null) page.width = w;
        if (h != null) page.height = h;
        await db.pageEntitys.put(page);
      } else {
        await db.pageEntitys.put(PageEntity(
          bookKomgaId: bookKomgaId,
          index: index,
          filePath: path,
          width: w,
          height: h,
        ));
      }
    });
  }
}
