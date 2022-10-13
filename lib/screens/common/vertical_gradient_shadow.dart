import 'package:flutter/material.dart';

class VerticalGradientShadow extends StatelessWidget {
  final double height;
  final Color upperColor;
  final Color lowerColor;
  final Alignment alignment;

  VerticalGradientShadow({
    required this.height,
    required this.alignment,
    required this.upperColor,
    required this.lowerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: alignment,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [upperColor, lowerColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
