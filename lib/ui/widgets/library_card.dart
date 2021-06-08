import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/library.dart';
import 'package:arc_comics/core/api/series.dart';
import 'package:arc_comics/ui/widgets/library_thumbnails.dart';

class LibraryCard extends StatefulWidget {
  final Library library;

  LibraryCard({
    required this.library,
  });

  @override
  _LibraryCardState createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard> {
  List<Series>? series1;
  List<Series>? series2;
  bool gotData = false;

  @override
  initState() {
    super.initState();
    startAsyncInit();
  }

  void checkData() {
    if (series1 != null && series2 != null) {
      gotData = true;
    }
  }

  Future<void> startAsyncInit() async {
    series1 = await fetchSeries(
      libraryId: widget.library.id,
      page: 0,
      size: 6,
    );
    series2 = await fetchSeries(
      libraryId: widget.library.id,
      page: 1,
      size: 6,
    );
    setState(() {
      checkData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.grey[600],
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/series', arguments: widget.library);
          },
          child: Stack(
            children: [
              Column(
                children: [
                  (gotData)
                      ? LibraryThumbnails(
                          series: series1!,
                        )
                      : Center(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  (gotData)
                      ? LibraryThumbnails(
                          series: series2!,
                        )
                      : Center(),
                ],
              ),
              Positioned(
                child: Container(
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    widget.library.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 48, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
