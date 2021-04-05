import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/globals.dart';

class BackgroundCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  final BorderRadius borderRadius = BorderRadius.circular(20);

  BackgroundCard({this.child, this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: theme.colors.appBarColor,
          borderRadius: borderRadius,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 4,
              blurRadius: 12,
              offset: Offset(0, 0),
            ),
          ]),
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: child,
        ),
      ),
    );
  }
}

BoxDecoration backgroundCardDecoration = BoxDecoration(
    color: theme.colors.appBarColor,
    borderRadius: BorderRadius.circular(17),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 5,
        offset: Offset(0, 0),
      ),
    ]);
