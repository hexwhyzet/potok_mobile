import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final Function onPressed;

  final Widget label;

  final bool isArrow;

  final BorderRadius borderRadius = BorderRadius.circular(10);

  BlueButton({this.onPressed, this.label, this.isArrow=false});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(0, 45),
        alignment: Alignment.center,
        elevation: 2,
        padding: isArrow ? EdgeInsets.fromLTRB(10, 7, 10, 7) : EdgeInsets.fromLTRB(22, 7, 22, 7),
        backgroundColor: Color.fromRGBO(20, 133, 255, 1),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      child: label,
    );
  }
}
