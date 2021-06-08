import 'package:flutter/material.dart';

import 'package:arc_comics/ui/views/serverView.dart';
import 'package:arc_comics/ui/views/libraryView.dart';
import 'package:arc_comics/ui/views/seriesView.dart';
import 'package:arc_comics/ui/views/booksView.dart';
import 'package:arc_comics/ui/views/bookView.dart';
import 'package:arc_comics/ui/views/readingView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ServerView(),
      routes: {
        '/library': (context) => LibraryView(),
        '/series': (context) => SeriesView(),
        '/books': (context) => BooksView(),
        '/book': (context) => BookView(),
        '/read': (context) => ReadingView(),
      },
    );
  }
}
