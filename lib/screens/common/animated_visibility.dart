import 'package:flutter/material.dart';

class AnimatedVisibility extends StatelessWidget {
  final Widget child;
  final bool visible;

  AnimatedVisibility({
    required this.child,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: visible ? 1 : 0,
      child: child,
    );
  }
}
