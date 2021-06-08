import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/server.dart';
import 'package:arc_comics/ui/widgets/server_card.dart';

class Servers extends StatelessWidget {
  final List<Server> servers;
  final VoidCallback callback;

  Servers({required this.servers, required this.callback});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: servers
              .map((server) => ServerCard(
                    server: server,
                    callback: callback,
                  ))
              .toList()),
    );
  }
}
