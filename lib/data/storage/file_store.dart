import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileStore {
  Future<Directory> booksDir() async {
    final base = await getApplicationSupportDirectory();
    final d = Directory(p.join(base.path, 'books'));
    if (!await d.exists()) await d.create(recursive: true);
    return d;
  }

  Future<Directory> _booksDir() async => booksDir();

  Future<File> pageFile(String bookKomgaId, int index) async {
    final dir = await booksDir();
    final bookDir = Directory(p.join(dir.path, bookKomgaId));
    if (!await bookDir.exists()) await bookDir.create(recursive: true);
    return File(p.join(bookDir.path, 'page_$index'));
  }

  /// Get total storage size used by cached pages
  Future<int> getTotalStorageSize() async {
    final dir = await _booksDir();
    if (!await dir.exists()) return 0;
    
    int totalSize = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }

  /// Get storage size for a specific book
  Future<int> getBookStorageSize(String bookKomgaId) async {
    final dir = await _booksDir();
    final bookDir = Directory(p.join(dir.path, bookKomgaId));
    if (!await bookDir.exists()) return 0;
    
    int totalSize = 0;
    await for (final entity in bookDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }
}
