import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/globals.dart';

Flushbar styledFlushbar(String text, Color color, IconData icon) {
  return Flushbar(
    icon: Padding(
      padding: EdgeInsets.only(left: 12),
      child: Icon(icon, color: Colors.white),
    ),
    shouldIconPulse: false,
    duration: Duration(milliseconds: 1250),
    margin: EdgeInsets.fromLTRB(8, 12, 8, 8),
    padding: EdgeInsets.all(15),
    borderRadius: 10,
    backgroundColor: color,
    messageText: Text(
      text,
      textAlign: TextAlign.left,
      style: theme.texts.flushbar,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    forwardAnimationCurve: Curves.easeOutCirc,
    reverseAnimationCurve: Curves.easeOutCirc,
    animationDuration: Duration(milliseconds: 500),
  );
}

Flushbar successFlushbar(String text) {
  return styledFlushbar(text, Color.fromRGBO(20, 133, 255, 1),
      Icons.check_circle_outline_rounded);
}

Flushbar errorFlushbar(String text) {
  return styledFlushbar(
      text, Color.fromRGBO(210, 0, 0, 1), Icons.error_outline_rounded);
}
