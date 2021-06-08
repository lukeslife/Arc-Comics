import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/book.dart';
import 'package:arc_comics/core/api/books.dart';
import 'package:arc_comics/ui/widgets/book_info.dart';

class BookView extends StatefulWidget {
  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  late Future<Book> futureBook;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Books book = ModalRoute.of(context)!.settings.arguments as Books;
    futureBook = fetchBook(
      id: book.id,
    );
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: Text(book.name),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: FutureBuilder<Book>(
          future: futureBook,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BookInfo(
                book: snapshot.data!,
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
