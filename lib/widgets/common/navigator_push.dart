import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/globals.dart';
import 'package:potok/icons.dart';

Route createRoute(Widget page) {
  return MaterialPageRoute(
    builder: (context) => page,
  );
}

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: IconTheme(
        data: theme.icons.backArrow,
        child: Icon(AppIcons.back),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class PictureViewerBackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: IconTheme(
        data: theme.icons.pictureViewerBackArrow,
        child: Icon(AppIcons.back),
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
