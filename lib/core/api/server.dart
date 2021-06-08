import 'dart:convert';

import 'package:arc_comics/ui/shared/globals.dart';

Future<void> addServer({
  required String key,
  required Server server,
}) async {
  if (server.url.contains('https://')) {
  } else {
    if (!server.url.contains('http://')) {
      server.url = 'http://' + server.url;
    }
  }

  if (!server.url.endsWith('/')) {
    server.url = server.url + '/';
  }

  if (!server.url.endsWith('api/v1/')) {
    server.url = server.url + 'api/v1/';
  }

  await Global.storage.write(key: key, value: jsonEncode(server.toJson()));
}

Future<void> addCurrentServer({
  required Server server,
}) async {
  await Global.storage
      .write(key: 'Current Server', value: jsonEncode(server.toJson()));
}

Future<Server> getCurrentServer() async {
  var data = await Global.storage.read(key: 'Current Server');

  Server server = Server.fromJson(jsonDecode(data!));

  return server;
}

Future<Server> getServer({
  required String key,
}) async {
  var data = await Global.storage.read(key: key);

  Server server = Server.fromJson(jsonDecode(data!));

  return server;
}

Future<List<Server>> getAllServers() async {
  Map<String, String> data = await Global.storage.readAll();
  List<Server> servers = [];

  List<ServerItem> serverItems = data.entries
      .map((entry) => ServerItem(
          key: entry.key, value: Server.fromJson(jsonDecode(entry.value))))
      .toList();

  for (int i = 0; i < serverItems.length; i++) {
    if (serverItems.elementAt(i).key != 'Current Server') {
      servers.add(serverItems.elementAt(i).value);
    }
  }

  return servers;
}

class Server {
  String name;
  String url;
  String username;
  String password;
  String key;

  Server({
    required this.name,
    required this.url,
    required this.username,
    required this.password,
    required this.key,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
        name: json['name'] as String,
        url: json['url'] as String,
        username: json['username'] as String,
        password: json['password'] as String,
        key: json['key'] as String);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name.toString();
    data['url'] = this.url.toString();
    data['username'] = this.username.toString();
    data['password'] = this.password.toString();
    data['key'] = this.key.toString();
    return data;
  }
}

class ServerItem {
  String key;
  Server value;

  ServerItem({
    required this.key,
    required this.value,
  });
}
