import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/images.dart';
import 'package:arc_comics/core/api/series.dart';

class LibraryThumbnails extends StatelessWidget {
  final List<Series> series;

  LibraryThumbnails({required this.series});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: series
            .map(
              (series) => LibraryThumbnail(
                id: series.id,
              ),
            )
            .toList());
  }
}
