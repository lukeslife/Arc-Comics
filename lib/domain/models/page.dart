import 'package:isar/isar.dart';
part 'page.g.dart';

@collection
class PageEntity {
  Id id;                // local PK
  final String bookKomgaId;
  final int index;      // 0-based
  String? filePath;     // local cached image path
  int? width;
  int? height;

  PageEntity({
    this.id = Isar.autoIncrement,
    required this.bookKomgaId,
    required this.index,
    this.filePath,
    this.width,
    this.height,
  });
}
