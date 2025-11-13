import 'package:isar/isar.dart';
import '../db/isar_schemas.dart';
import '../../domain/models/settings.dart';

class SettingsRepo {
  Future<SettingsEntity> load() async {
    final db = await AppDb.open();
    final s = await db.settingsEntitys.get(0);
    if (s != null) return s;
    final def = SettingsEntity();
    await db.writeTxn(() => db.settingsEntitys.put(def));
    return def;
  }

  Future<void> save(SettingsEntity s) async {
    final db = await AppDb.open();
    await db.writeTxn(() => db.settingsEntitys.put(s));
  }
}
