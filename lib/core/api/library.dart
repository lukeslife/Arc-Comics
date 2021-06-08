import 'dart:convert';

import 'package:http/http.dart';
import 'package:arc_comics/core/api/auth.dart';
import 'package:arc_comics/core/api/server.dart';

Future<List<Library>> fetchLibraries() async {
  List<Library> libraries;
  Server server = await getCurrentServer();

  var response = await get(Uri.parse(server.url + 'libraries'),
      headers: auth(
        username: server.username,
        password: server.password,
      ));

  var data = jsonDecode(utf8.decode(response.bodyBytes));
  libraries = data.map<Library>((json) => Library.fromJson(json)).toList();
  return libraries;
}

class Library {
  String id;
  String name;

  Library({
    required this.id,
    required this.name,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
