import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;

  // final TextStyle textStyle;
  final Widget label;

  final BorderRadius borderRadius = BorderRadius.circular(8);

  BlueButton({this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        alignment: Alignment.center,
        elevation: 2,
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        backgroundColor: Color.fromRGBO(20, 133, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      child: label,
    );
  }
}
