import 'package:flutter/cupertino.dart';

class BouncingWidget extends StatelessWidget {
  final Widget child;

  BouncingWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        child,
      ],
    );
  }
}