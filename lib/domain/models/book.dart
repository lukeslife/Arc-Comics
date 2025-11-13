import 'package:isar/isar.dart';
part 'book.g.dart';

@collection
class BookEntity {
  Id id;                       // local PK
  final String komgaId;        // Komga book id
  final String seriesKomgaId;  // parent series id
  final String title;
  final int pageCount;
  final int number;            // series index if available (else 0)
  final DateTime updatedAt;
  final String? mediaType;   // e.g. application/epub+zip, application/pdf, image/*

  // download state
  bool isPinned;               // never evict if true
  bool isDownloaded;           // all pages present
  DateTime? lastOpenedAt;
  
  // reading progress
  int currentPageIndex;        // 0-based index of current page
  int readPageCount;           // number of pages read (for progress calculation)

  BookEntity({
    this.id = Isar.autoIncrement,
    required this.komgaId,
    required this.seriesKomgaId,
    required this.title,
    required this.pageCount,
    required this.number,
    required this.updatedAt,
    this.mediaType, 
    this.isPinned = false,
    this.isDownloaded = false,
    this.lastOpenedAt,
    this.currentPageIndex = 0,
    this.readPageCount = 0,
  });
}
