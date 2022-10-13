import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potok/configs/theme_data.dart';
import 'package:potok/resources/functions/snackbar.dart';

Flushbar styledFlushbar(
    BuildContext context, String text, Color color, IconData icon) {
  return Flushbar(
    icon: Padding(
      padding: EdgeInsets.only(left: 12),
      child: Icon(icon, color: Colors.white),
    ),
    shouldIconPulse: false,
    duration: Duration(milliseconds: 1250),
    margin: EdgeInsets.fromLTRB(8, 12, 8, 8),
    padding: EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(10),
    backgroundColor: color,
    messageText: Text(
      text,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.headline4!.copyWith(color: WHITE),
    ),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    forwardAnimationCurve: Curves.easeOutCirc,
    reverseAnimationCurve: Curves.easeOutCirc,
    animationDuration: Duration(milliseconds: 500),
  );
}

Flushbar successFlushbar(BuildContext context, String title) {
  return styledFlushbar(
    context,
    title,
    BLUE,
    Icons.check_circle_outline_rounded,
  );
}

Flushbar errorFlushbar(BuildContext context, String title) {
  return styledFlushbar(
    context,
    title,
    RED,
    Icons.error_outline_rounded,
  );
}

void showInfoSnackbar(BuildContext context, InfoSnackbar infoSnackbar) {
  if (infoSnackbar.infoSnackbarStyle == InfoSnackbarStyle.success) {
    successFlushbar(context, infoSnackbar.title).show(context);
  } else if (infoSnackbar.infoSnackbarStyle == InfoSnackbarStyle.failure) {
    errorFlushbar(context, infoSnackbar.title).show(context);
  }
}
