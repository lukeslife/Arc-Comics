import 'dart:convert';

import 'package:http/http.dart';
import 'package:arc_comics/core/api/auth.dart';

Future<User> getUser({
  required String url,
  required String username,
  required String password,
}) async {
  User user;

  var response = await get(Uri.parse(url + 'users/me'),
      headers: auth(
        username: username,
        password: password,
      ));

  var data = jsonDecode(response.body);
  user = User.fromJson(data);

  return user;
}

class User {
  String id;
  String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
    );
  }
}
