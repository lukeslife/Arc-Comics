import 'package:arc_comics/ui/widgets/search_series.dart';
import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/library.dart';
import 'package:arc_comics/core/api/series.dart';
import 'package:arc_comics/ui/widgets/series_grid.dart';

class SeriesView extends StatefulWidget {
  @override
  _SeriesViewState createState() => _SeriesViewState();
}

class _SeriesViewState extends State<SeriesView> {
  late Future<List<Series>> futureSeries;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Library library = ModalRoute.of(context)!.settings.arguments as Library;
    futureSeries = fetchSeries(
      libraryId: library.id,
      size: 1000,
      page: 0,
    );
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(library.name),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchSeries(id: library.id));
                },
                icon: Icon(Icons.search))
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<List<Series>>(
          future: futureSeries,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SeriesGrid(
                series: snapshot.data!,
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
