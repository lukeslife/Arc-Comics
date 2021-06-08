import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/books.dart';
import 'package:arc_comics/ui/widgets/books_card.dart';

class BooksGrid extends StatelessWidget {
  final List<Books> books;

  BooksGrid({
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: .65,
      crossAxisCount: 2,
      children: books
          .map((books) => BooksCard(
                books: books,
              ))
          .toList(),
    );
  }
}
