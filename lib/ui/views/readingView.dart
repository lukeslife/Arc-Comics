import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preload_page_view/preload_page_view.dart';

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
  bool reverse = false;
  bool visible = false;
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Book book = ModalRoute.of(context)!.settings.arguments as Book;

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Stack(
      children: [
        PreloadPageView.builder(
          reverse: reverse,
          preloadPagesCount: 4,
          itemCount: book.media.pageCount,
          itemBuilder: (BuildContext context, int position) {
            return BookImage(id: book.id, page: position);
          },
          controller:
              PreloadPageController(initialPage: book.readProgress.page),
          onPageChanged: (int position) {
            setState(() {
              book.readProgress.page = position;
            });
            updateReadProgress(
              id: book.id,
              data: book.readProgress.toJson(),
            );
          },
        ),
        SafeArea(
          child: Container(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Container(
                  width: 100,
                  child: GestureDetector(
                    onTap: () => setState(() => visible = !visible),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
        Column(
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
                    height: 80,
                    child: SlideDown(
                      controller: controller,
                      visible: visible,
                      child: Container(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  reverse = !reverse;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Yay! A SnackBar!'),
                                  ),
                                );
                              },
                              icon: Icon(
                                reverse ? Icons.arrow_left : Icons.arrow_right,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Slider(
                      //     value: book.readProgress.page.toDouble(),
                      //     min: 0,
                      //     max: (book.media.pageCount - 1).toDouble(),
                      //     label:
                      //         (book.readProgress.page + 1).round().toString(),
                      //     onChanged: (double value) {
                      //       setState(() {
                      //         book.readProgress.page = value.toInt();
                      //       });
                      //       updateReadProgress(
                      //         id: book.id,
                      //         data: book.readProgress.toJson(),
                      //       );
                      //     }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
