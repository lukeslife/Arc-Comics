import 'dart:convert';

import 'package:http/http.dart';
import 'package:arc_comics/core/api/auth.dart';
import 'package:arc_comics/core/api/server.dart';

Future<Book> fetchBook({
  required String id,
}) async {
  Book book;
  Server server = await getCurrentServer();

  final response = await get(Uri.parse(server.url + 'books/' + id),
      headers: auth(
        username: server.username,
        password: server.password,
      ));
  var data = jsonDecode(utf8.decode(response.bodyBytes));
  book = Book.fromJson(data);
  return book;
}

Future<void> updateReadProgress({
  required String id,
  required Map<String, dynamic> data,
}) async {
  Server server = await getCurrentServer();
  await patch(Uri.parse(server.url + 'books/' + id + '/read-progress'),
      headers: authPatch(username: server.username, password: server.password),
      body: jsonEncode(data));
}

class Book {
  String id;
  String name;
  BookMetadata metadata;
  BookMedia media;
  BookReadProgress readProgress;

  Book({
    required this.id,
    required this.name,
    required this.metadata,
    required this.media,
    required this.readProgress,
  });

  factory Book.fromJson(dynamic json) {
    BookReadProgress readProgress;

    readProgress = json['readProgress'] == null
        ? new BookReadProgress(page: 0, completed: false)
        : new BookReadProgress.fromJson(json['readProgress']);

    return Book(
      id: json['id'] as String,
      name: json['name'] as String,
      metadata: BookMetadata.fromJson(json['metadata']),
      media: BookMedia.fromJson(json['media']),
      readProgress: readProgress,
    );
  }
}

class BookMetadata {
  String title;
  String summary;

  BookMetadata({
    required this.title,
    required this.summary,
  });

  factory BookMetadata.fromJson(Map<String, dynamic> json) {
    return BookMetadata(
      title: json['title'],
      summary: json['summary'],
    );
  }
}

class BookMedia {
  int pageCount;

  BookMedia({
    required this.pageCount,
  });

  factory BookMedia.fromJson(Map<String, dynamic> json) {
    return BookMedia(pageCount: json['pagesCount']);
  }
}

class BookReadProgress {
  int page;
  bool completed;

  BookReadProgress({
    required this.page,
    required this.completed,
  });

  factory BookReadProgress.fromJson(Map<String, dynamic> json) {
    return BookReadProgress(
        page: json['page'] as int, completed: json['completed'] as bool);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page.toString();
    data['completed'] = this.completed.toString();
    return data;
  }
}
