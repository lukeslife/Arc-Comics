import 'package:arc_comics/ui/widgets/search_series.dart';
import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/library.dart';
import 'package:arc_comics/ui/widgets/libraries.dart';

class LibraryView extends StatefulWidget {
  @override
  _LibraryViewState createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late Future<List<Library>> futureLibraries;

  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    setState(() {
      futureLibraries = fetchLibraries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text('Libraries'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(context: context, delegate: SearchSeries());
                },
                icon: Icon(Icons.search))
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Library>>(
          future: futureLibraries,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Libraries(
                library: snapshot.data!,
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
