import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:arc_comics/core/viewmodels/addServerModel.dart';
import 'package:arc_comics/ui/shared/globals.dart';
import 'package:arc_comics/ui/views/pickServer.dart';
import 'package:arc_comics/ui/views/addServer.dart';

class ServerView extends StatefulWidget {
  @override
  _ServerViewState createState() => _ServerViewState();
}

class _ServerViewState extends State<ServerView> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    serverCheck();
  }

  void setPage() {
    setState(() {
      selectedIndex = 1;
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void serverCheck() {
    Global.storage.containsKey(key: '0').then((value) {
      setState(() {
        if (!value) {
          selectedIndex = 0;
        } else {
          selectedIndex = 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final List<Widget> widgetOptions = [
      AddServer(
        keyboardOpen: keyboardOpen,
        callback: () {
          setPage();
        },
      ),
      PickServer(keyboardOpen),
    ];
    return ChangeNotifierProvider(
      create: (context) => AddServerModel(),
      child: Scaffold(
        body: widgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Server',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storage_outlined),
              label: 'Pick Server',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: onItemTapped,
        ),
      ),
    );
  }
}
