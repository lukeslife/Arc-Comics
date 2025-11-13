import 'dart:io';
import '../../data/api/komga_client.dart';
import '../../data/repos/book_repo.dart';
import '../../data/repos/page_repo.dart';
import '../../data/storage/file_store.dart';

class DownloadService {
  final KomgaClient _api;
  final BookRepo _books;
  final PageRepo _pages;
  final FileStore _fs;
  DownloadService(this._api, this._books, this._pages, this._fs);

  /// Downloads all pages for a book to local storage.
  /// Simple sequential impl; parallelism can be added later.
  Future<void> downloadBook(String bookKomgaId, int pageCount) async {
    for (int i = 0; i < pageCount; i++) {
      final oneBased = i + 1;
      final bytesRes = await _api.fetchPageBytes(bookKomgaId, oneBased);
      final file = await _fs.pageFile(bookKomgaId, i);
      await file.writeAsBytes(bytesRes.data!, flush: true);
      await _pages.setLocalPath(bookKomgaId, i, file.path);
    }
    await _books.markDownloaded(bookKomgaId, true);
  }
}
