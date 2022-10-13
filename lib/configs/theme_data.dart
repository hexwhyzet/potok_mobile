import 'package:flutter/material.dart';

const GREY = Color.fromRGBO(105, 105, 105, 1);
const SEMI_GREY = Color.fromRGBO(150, 150, 150, 1);
const LIGHT_GREY = Color.fromRGBO(190, 190, 190, 1);
const SUPER_LIGHT_GREY = Color.fromRGBO(247, 247, 247, 1);
const BLACK = Colors.black;
const WHITE = Colors.white;
const BLUE = Color.fromRGBO(20, 133, 255, 1);
const RED = Color.fromRGBO(255, 18, 57, 0.9);

final textTheme = TextTheme(
  headline1: TextStyle(
    fontSize: 48,
    color: BLACK,
  ),
  headline2: TextStyle(
    fontSize: 36,
    color: BLACK,
  ),
  headline3: TextStyle(
    fontSize: 26,
    color: BLACK,
  ),
  headline4: TextStyle(
    fontSize: 22,
    color: BLACK,
  ),
  headline5: TextStyle(
    fontSize: 18,
    color: BLACK,
  ),
  headline6: TextStyle(
    fontSize: 14,
    color: BLACK,
  ),
  bodyText1: TextStyle(
    fontSize: 12,
    color: BLACK,
  ),
  bodyText2: TextStyle(
    fontSize: 8,
    color: BLACK,
  ),
);

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: WHITE,
    elevation: 0.1,
    titleTextStyle: textTheme.headline4,
  ),
  bottomAppBarTheme: BottomAppBarTheme(
    color: WHITE,
  ),
  selectedRowColor: BLACK,
  dialogBackgroundColor: BLACK,
  unselectedWidgetColor: SEMI_GREY,
  brightness: Brightness.light,
  backgroundColor: SUPER_LIGHT_GREY,
  bottomAppBarColor: WHITE,
  accentColor: BLUE,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: LIGHT_GREY,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
  fontFamily: 'Sofia',
  textTheme: textTheme,
);

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    color: WHITE,
  ),
  bottomAppBarTheme: BottomAppBarTheme(
    color: WHITE,
  ),
  selectedRowColor: BLACK,
  unselectedWidgetColor: GREY,
  brightness: Brightness.light,
  backgroundColor: BLACK,
  bottomAppBarColor: WHITE,
  accentColor: BLUE,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: LIGHT_GREY,
  splashColor: Colors.transparent,
  highlightColor: Colors.transparent,
);
