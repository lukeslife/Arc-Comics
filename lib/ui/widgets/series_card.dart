import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/images.dart';
import 'package:arc_comics/core/api/series.dart';

class SeriesCard extends StatelessWidget {
  final Series series;
  SeriesCard({required this.series});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/books', arguments: series);
        },
        child: Stack(
          children: [
            Thumbnail(
              id: series.id,
              type: 'series',
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black87,
                padding: EdgeInsets.all(10),
                width: 120,
                child: Text(
                  series.name,
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
