import 'dart:convert';

import 'package:http/http.dart';
import 'package:arc_comics/core/api/auth.dart';
import 'package:arc_comics/core/api/server.dart';

Future<List<Series>> fetchSeries({
  required String libraryId,
  required int size,
  required int page,
}) async {
  List<Series> series;
  Server server = await getCurrentServer();

  var response = await get(
      Uri.parse(
          server.url + 'series?library_id=$libraryId&page=$page&size=$size'),
      headers: auth(
        username: server.username,
        password: server.password,
      ));
  var data = jsonDecode(response.body)['content'];
  series = data.map<Series>((json) => Series.fromJson(json)).toList();
  return series;
}

Future<List<Series>> searchSeries({
  String? libraryId,
  required String search,
  required int size,
  required int page,
}) async {
  List<Series> series;
  Server server = await getCurrentServer();

  var response;
  if (libraryId == null) {
    response = await get(
        Uri.parse(server.url + 'series?search=$search&page=$page&size=$size'),
        headers: auth(
          username: server.username,
          password: server.password,
        ));
  } else {
    response = await get(
        Uri.parse(server.url +
            'series?library_id=$libraryId&search=$search&page=$page&size=$size'),
        headers: auth(
          username: server.username,
          password: server.password,
        ));
  }

  var data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
  series = data.map<Series>((json) => Series.fromJson(json)).toList();
  return series;
}

class Series {
  String id;
  String name;

  Series({
    required this.id,
    required this.name,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
