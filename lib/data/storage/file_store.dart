import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileStore {
  Future<Directory> _booksDir() async {
    final base = await getApplicationSupportDirectory();
    final d = Directory(p.join(base.path, 'books'));
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  Future<File> pageFile(String bookKomgaId, int index) async {
    final dir = await _booksDir();
    final bookDir = Directory(p.join(dir.path, bookKomgaId));
    if (!await bookDir.exists()) await bookDir.create(recursive: true);
    return File(p.join(bookDir.path, 'page_$index'));
  }
}
