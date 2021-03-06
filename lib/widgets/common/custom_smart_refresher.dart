import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSmartRefresher extends StatefulWidget {
  final Widget child;

  CustomSmartRefresher({this.child});

  @override
  _CustomSmartRefresherState createState() => _CustomSmartRefresherState();
}

class _CustomSmartRefresherState extends State<CustomSmartRefresher> {
  // RefreshController _refreshController =
  //     RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {},
      // controller: _refreshController,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (index, context) {
          return widget.child;
        },
        itemCount: 1,
      ),
    );
  }
}
