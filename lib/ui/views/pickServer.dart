import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/server.dart';
import 'package:arc_comics/ui/shared/globals.dart';
import 'package:arc_comics/ui/widgets/servers.dart';
import 'package:arc_comics/ui/widgets/wave_widget.dart';

class PickServer extends StatefulWidget {
  final bool keyboardOpen;

  PickServer(this.keyboardOpen);

  @override
  _PickServerState createState() => _PickServerState();
}

class _PickServerState extends State<PickServer> {
  late Future<List<Server>> futureServers;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    serverCheck();
    getSevers();
  }

  Future<void> getSevers() async {
    setState(() {
      futureServers = startAsyncInit();
    });
  }

  Future<List<Server>> startAsyncInit() async {
    List<Server> servers;
    servers = await getAllServers();
    return servers;
  }

  void serverCheck() {
    Global.storage.containsKey(key: '0').then((value) {
      setState(() {
        if (!value) {
          hasData = false;
        } else {
          hasData = true;
        }
      });
    });
  }

  void onDelete() {
    serverCheck();
    setState(() {
      getSevers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Global.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            top: widget.keyboardOpen ? -size.height / 3.0 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              color: Global.blue,
              height: 20.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 150.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pick Server',
                  style: TextStyle(
                    color: Global.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Container(
                  height: 400,
                  child: hasData
                      ? FutureBuilder<List<Server>>(
                          future: futureServers,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Servers(
                                servers: snapshot.data!,
                                callback: onDelete,
                              );
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }
                            return CircularProgressIndicator();
                          },
                        )
                      : Center(
                          child: Text(
                            'Add a server first',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
