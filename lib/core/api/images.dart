import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/auth.dart';
import 'package:arc_comics/core/api/server.dart';

class LibraryThumbnail extends StatelessWidget {
  final String id;

  LibraryThumbnail({
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentServer(),
      builder: (context, AsyncSnapshot<Server> snapshot) {
        if (snapshot.hasData) {
          Server server = snapshot.data!;
          return Expanded(
            flex: 1,
            child: Image(
              fit: BoxFit.fill,
              height: 100,
              image: NetworkImage(
                server.url + 'series/' + id + '/thumbnail',
                headers: auth(
                  username: server.username,
                  password: server.password,
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Thumbnail extends StatelessWidget {
  final String id;
  final int height;
  final String type;

  Thumbnail({
    required this.id,
    required this.type,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentServer(),
      builder: (context, AsyncSnapshot<Server> snapshot) {
        if (snapshot.hasData) {
          Server server = snapshot.data!;
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            elevation: 2.0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            type: MaterialType.transparency,
            child: Image(
              image: NetworkImage(server.url + type + '/' + id + '/thumbnail',
                  headers: auth(
                    username: server.username,
                    password: server.password,
                  )),
              height: height.toDouble(),
              fit: BoxFit.cover,
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class BookImage extends StatelessWidget {
  final String id;
  final int page;

  BookImage({
    required this.id,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentServer(),
      builder: (context, AsyncSnapshot<Server> snapshot) {
        if (snapshot.hasData) {
          Server server = snapshot.data!;
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            elevation: 2.0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            type: MaterialType.transparency,
            child: SafeArea(
              child: Container(
                child: InteractiveViewer(
                  child: Image(
                    image: NetworkImage(
                        server.url +
                            'books/' +
                            id +
                            '/pages/' +
                            page.toString() +
                            '?zero_based=true',
                        headers: auth(
                          username: server.username,
                          password: server.password,
                        )),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
