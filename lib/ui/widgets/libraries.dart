import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/library.dart';
import 'package:arc_comics/ui/widgets/library_card.dart';

class Libraries extends StatelessWidget {
  final List<Library> library;

  Libraries({
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: library
            .map((library) => LibraryCard(
                  library: library,
                ))
            .toList(),
      ),
    );
  }
}
