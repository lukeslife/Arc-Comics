import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/server.dart';
import 'package:arc_comics/core/api/user.dart';
import 'package:arc_comics/ui/shared/globals.dart';

class ServerCard extends StatefulWidget {
  final Server server;
  final VoidCallback callback;

  ServerCard({required this.server, required this.callback});

  @override
  _ServerCardState createState() => _ServerCardState();
}

class _ServerCardState extends State<ServerCard> {
  bool checkServer = false;

  @override
  void initState() {
    super.initState();
    serverCheck();
  }

  void serverCheck() async {
    User user = await getUser(
      url: widget.server.url,
      username: widget.server.username,
      password: widget.server.password,
    );
    if (user.email.contains('@')) {
      setState(() {
        checkServer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: () {
            widget.server.key = 'Current Server';
            addCurrentServer(server: widget.server);
            Navigator.pushNamed(context, '/library');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    widget.server.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(widget.server.url),
                  Row(
                    children: [
                      checkServer
                          ? Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.dangerous,
                              color: Colors.red,
                            ),
                      checkServer
                          ? Text('Server Online')
                          : Text('Server Offline'),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      widget.callback();
                      Global.storage.delete(key: widget.server.key);
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
