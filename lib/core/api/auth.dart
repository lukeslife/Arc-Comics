import 'dart:convert';

Map<String, String> auth({
  required String username,
  required String password,
}) {
  final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Map<String, String> client = {
    'authorization': basicAuth,
    'Content-Type': 'application/json; charset=utf-8'
  };

  return client;
}

Map<String, String> authPatch({
  required String username,
  required String password,
}) {
  final basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

  Map<String, String> client = {
    'authorization': basicAuth,
    'accept': '*/*',
    'Content-Type': 'application/json'
  };

  return client;
}
