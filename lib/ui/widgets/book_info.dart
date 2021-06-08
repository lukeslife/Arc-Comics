import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/book.dart';
import 'package:arc_comics/core/api/images.dart';

class BookInfo extends StatefulWidget {
  final Book book;

  BookInfo({
    required this.book,
  });

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Thumbnail(
                  id: widget.book.id,
                  type: 'books',
                ),
                Container(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.book.metadata.title,
                      style: TextStyle(color: Colors.white),
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.auto_stories),
                  label: Text('Read'),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/read',
                      arguments: widget.book,
                    );
                  },
                ),
                Text('Pages:', style: TextStyle(color: Colors.white)),
                Text(
                  (() {
                    if (widget.book.readProgress.page == 0) {
                      return 'Unread';
                    } else {
                      return widget.book.readProgress.page.toString() +
                          ' / ' +
                          widget.book.media.pageCount.toString();
                    }
                  })(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    widget.book.metadata.summary,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
