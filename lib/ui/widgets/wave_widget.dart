import 'package:flutter/material.dart';
import 'dart:math' as Math;

import 'package:arc_comics/ui/shared/globals.dart';
import 'package:arc_comics/ui/widgets/clipper_widget.dart';

class WaveWidget extends StatefulWidget {
  final Size size;
  final double yOffset;
  final Color color;
  final double height;

  WaveWidget({
    required this.size,
    required this.yOffset,
    required this.color,
    required this.height,
  });

  @override
  _WaveWidgetState createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveWidget> with TickerProviderStateMixin {
  late AnimationController animationController;

  List<Offset> wavePoints = [];

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 5000))
          ..addListener(() {
            wavePoints.clear();
            final double waveSpeed = animationController.value * 1080;
            final double fullSphere = animationController.value * Math.pi * 2;
            final double normalizer = Math.cos(fullSphere);
            final double waveWidth = Math.pi / 270;
            final double waveHeight = widget.height;

            for (int i = 0; i <= widget.size.width.toInt(); i++) {
              double calc = Math.sin((waveSpeed - i) * waveWidth);

              wavePoints.add(
                Offset(
                  i.toDouble(),
                  calc * waveHeight * normalizer + widget.yOffset,
                ),
              );
            }
          });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return Container(
          color: widget.color,
          child: ClipPath(
            clipper: ClipperWidget(
              waveList: wavePoints,
            ),
            child: Container(
              width: widget.size.height,
              height: widget.size.width,
              color: Global.white,
            ),
          ),
        );
      },
    );
  }
}
