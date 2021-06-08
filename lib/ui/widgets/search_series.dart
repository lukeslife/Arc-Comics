import 'package:flutter/material.dart';

import 'package:arc_comics/core/api/images.dart';
import 'package:arc_comics/core/api/series.dart';

class SearchSeries extends SearchDelegate {
  String? id;

  SearchSeries({this.id});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    var search = searchSeries(search: query, libraryId: id, page: 0, size: 100);

    final availableHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).viewInsets.bottom;

    return Column(
      children: <Widget>[
        FutureBuilder(
          future: search,
          builder: (context, AsyncSnapshot<List<Series>> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: availableHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              );
            } else if (snapshot.data!.length == 0) {
              return Column(
                children: [
                  Center(
                    child: Text(
                      "No Results Found.",
                    ),
                  ),
                ],
              );
            } else {
              var results = snapshot.data;
              return Container(
                height: availableHeight,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results!.length,
                  itemBuilder: (context, index) {
                    var result = results[index];
                    return Padding(
                      padding: EdgeInsets.fromLTRB(0, 1, 0, 1),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/books',
                              arguments: result);
                        },
                        leading: Container(
                          width: 40,
                          child: Thumbnail(
                            id: result.id,
                            type: 'series',
                          ),
                        ),
                        title: Text(result.name),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: Column(
          children: [
            Text('Searching for...'),
            Text(query),
          ],
        ),
      ),
    );
    // final availableHeight = MediaQuery.of(context).size.height -
    //     AppBar().preferredSize.height -
    //     MediaQuery.of(context).padding.top -
    //     MediaQuery.of(context).padding.bottom -
    //     MediaQuery.of(context).viewInsets.bottom;
    // var search = searchSeries(search: query, size: 1000, page: 0);

    // return Column(
    //   children: <Widget>[
    //     FutureBuilder(
    //       future: search,
    //       builder: (context, AsyncSnapshot<List<Series>> snapshot) {
    //         if (!snapshot.hasData) {
    //           return Container(
    //             height: availableHeight,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Center(child: CircularProgressIndicator()),
    //               ],
    //             ),
    //           );
    //         } else if (snapshot.data.length == 0) {
    //           return Column(
    //             children: [
    //               Center(
    //                 child: Text(
    //                   "No Results Found.",
    //                 ),
    //               ),
    //             ],
    //           );
    //         } else {
    //           var results = snapshot.data;
    //           return SingleChildScrollView(
    //             child: Container(
    //               height: availableHeight,
    //               child: ListView.builder(
    //                 shrinkWrap: true,
    //                 itemCount: results.length,
    //                 itemBuilder: (context, index) {
    //                   var result = results[index];
    //                   return ListTile(

    //                     leading: Thumbnail(
    //                       id: result.id,
    //                       type: 'series',
    //                     ),
    //                     title: Text(result.name),
    //                   );
    //                 },
    //               ),
    //             ),
    //           );
    //         }
    //       },
    //     ),
    //   ],
    // );
  }
}
