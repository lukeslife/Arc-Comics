import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/books.dart';
import 'package:arc_comics/core/api/series.dart';
import 'package:arc_comics/ui/widgets/books_grid.dart';

class BooksView extends StatefulWidget {
  @override
  _BooksViewState createState() => _BooksViewState();
}

class _BooksViewState extends State<BooksView> {
  late Future<List<Books>> futureSeries;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Series series = ModalRoute.of(context)!.settings.arguments as Series;
    futureSeries = fetchBooks(
      id: series.id,
    );
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(series.name),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: FutureBuilder<List<Books>>(
          future: futureSeries,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BooksGrid(
                books: snapshot.data!,
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
