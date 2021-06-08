import 'dart:convert';

import 'package:http/http.dart';
import 'package:arc_comics/core/api/auth.dart';
import 'package:arc_comics/core/api/server.dart';

Future<List<Books>> fetchBooks({
  required String id,
}) async {
  List<Books> books;
  Server server = await getCurrentServer();

  final response = await get(
      Uri.parse(server.url + 'series/' + id + '/books?page=0&size=1000'),
      headers: auth(username: server.username, password: server.password));
  var data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
  books = data.map<Books>((json) => Books.fromJson(json)).toList();

  return books;
}

class Books {
  String id;
  String name;

  Books({
    required this.id,
    required this.name,
  });

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
