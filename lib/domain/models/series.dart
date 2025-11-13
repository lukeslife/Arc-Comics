import 'package:isar/isar.dart';
part 'series.g.dart';

@collection
class SeriesEntity {
  Id id; // use Komga's series id hashed or a separate numeric id
  final String komgaId;
  final String title;
  final String? thumbnailUrl;
  final int booksCount;
  final DateTime updatedAt;
  DateTime? lastOpenedAt;
  
  // Rich metadata
  final String? publisher;
  final String? description;
  final String? ageRating;
  final DateTime? releaseDate;

  SeriesEntity({
    this.id = Isar.autoIncrement,
    required this.komgaId,
    required this.title,
    this.thumbnailUrl,
    required this.booksCount,
    required this.updatedAt,
    this.lastOpenedAt,
    this.publisher,
    this.description,
    this.ageRating,
    this.releaseDate,
  });
}
