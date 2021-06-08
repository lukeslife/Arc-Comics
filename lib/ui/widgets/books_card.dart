import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/books.dart';
import 'package:arc_comics/core/api/images.dart';

class BooksCard extends StatelessWidget {
  final Books books;

  BooksCard({required this.books});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/book', arguments: books);
        },
        child: Stack(
          children: [
            Thumbnail(
              id: books.id,
              type: 'books',
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black87,
                padding: EdgeInsets.all(10),
                width: 120,
                child: Text(
                  books.name,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
