import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/series.dart';
import '../../domain/models/book.dart';
import '../../domain/models/page.dart';
import '../../domain/models/settings.dart';
import '../storage/progress_sync_queue.dart';

class AppDb {
  static Isar? _isar;

  static Future<Isar> open() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationSupportDirectory();
    _isar = await Isar.open(
      [
        SeriesEntitySchema,
        BookEntitySchema,
        PageEntitySchema,
        SettingsEntitySchema,
        ProgressSyncEntitySchema,
      ],
      directory: dir.path,
    );
    return _isar!;
  }
}
