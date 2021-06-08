import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/series.dart';
import 'package:arc_comics/ui/widgets/series_card.dart';

class SeriesGrid extends StatelessWidget {
  final List<Series> series;

  SeriesGrid({required this.series});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: .65,
      crossAxisCount: 2,
      children: series
          .map((series) => SeriesCard(
                series: series,
              ))
          .toList(),
    );
  }
}
