import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/series.dart';
import '../../domain/models/book.dart';
import '../../domain/models/page.dart';
import '../../domain/models/settings.dart';

class AppDb {
  static Isar? _isar;

  static Future<Isar> open() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationSupportDirectory();
    _isar = await Isar.open(
  [SeriesEntitySchema, BookEntitySchema, PageEntitySchema, SettingsEntitySchema],
  directory: dir.path,
);
    return _isar!;
  }
}
