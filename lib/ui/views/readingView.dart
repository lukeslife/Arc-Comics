import 'package:flutter/material.dart';

import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:arc_comics/core/api/book.dart';
import 'package:arc_comics/core/api/images.dart';
import 'package:arc_comics/ui/widgets/slide_up.dart';
import 'package:arc_comics/ui/widgets/slide_down.dart';

class ReadingView extends StatefulWidget {
  @override
  _ReadingViewState createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView>
    with SingleTickerProviderStateMixin {
  bool visible = false;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void nextPage({required Book book}) {
    if (book.readProgress.page < (book.media.pageCount - 1)) {
      setState(() {
        book.readProgress.page += 1;
      });
    }
    updateReadProgress(
      id: book.id,
      data: book.readProgress.toJson(),
    );
  }

  void previousPage({required Book book}) {
    if (book.readProgress.page > 0) {
      setState(() {
        book.readProgress.page -= 1;
      });
    }
    if (book.readProgress.page == 0) {
      updateReadProgress(
        id: book.id,
        data: book.readProgress.toJson(),
      );
    }
    updateReadProgress(
      id: book.id,
      data: book.readProgress.toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)!.settings.arguments as Book;

    return Stack(
      children: [
        SimpleGestureDetector(
          swipeConfig: SimpleSwipeConfig(
            verticalThreshold: 40.0,
            horizontalThreshold: 200.0,
            swipeDetectionBehavior: SwipeDetectionBehavior.continuous,
          ),
          onHorizontalSwipe: (direction) {
            if (direction == SwipeDirection.left) {
              nextPage(book: book);
            } else {
              previousPage(book: book);
            }
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: BookImage(
              id: book.id,
              page: book.readProgress.page,
            ),
          ),
        ),
        SafeArea(
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        previousPage(book: book);
                      },
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  child: GestureDetector(
                    onTap: () => setState(() => visible = !visible),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        nextPage(book: book);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: SlideUp(
                  controller: controller,
                  visible: visible,
                  child: Container(
                    child: Row(
                      children: [
                        BackButton(
                          color: Colors.white,
                        ),
                        Text(
                          book.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: 50,
                      child: SlideDown(
                        controller: controller,
                        visible: visible,
                        child: Slider(
                            value: book.readProgress.page.toDouble(),
                            min: 0,
                            max: (book.media.pageCount - 1).toDouble(),
                            divisions: book.media.pageCount,
                            label:
                                (book.readProgress.page + 1).round().toString(),
                            onChanged: (double value) {
                              setState(() {
                                book.readProgress.page = value.toInt();
                              });
                              updateReadProgress(
                                id: book.id,
                                data: book.readProgress.toJson(),
                              );
                            }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
