import 'package:flutter/material.dart';
import 'package:potok/configs/icons.dart';

class BackArrowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Theme.of(context).appBarTheme.foregroundColor,
      tooltip: 'Back',
      icon: Icon(
        AppIcons.back,
        size: 40,
      ),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}
