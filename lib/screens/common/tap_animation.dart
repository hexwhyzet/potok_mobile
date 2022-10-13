import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

class TapAnimation extends StatelessWidget {
  final Widget child;
  final AnimatorKey<double> animatorKey;

  TapAnimation({required this.child, required this.animatorKey});

  @override
  Widget build(BuildContext context) {
    return Animator<double>(
      animatorKey: animatorKey,
      tween: Tween<double>(begin: 0, end: 2),
      repeats: 1,
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
      builder: (context, animatorState, child) {
        if (animatorState.value < 1) {
          return Center(
            child: Transform.scale(
              scale: 1 - animatorState.value / 7,
              child: this.child,
            ),
          );
        } else {
          return Center(
            child: Transform.scale(
              scale: 1 - ((2 - animatorState.value) / 7),
              child: this.child,
            ),
          );
        }
      },
    );
  }
}
