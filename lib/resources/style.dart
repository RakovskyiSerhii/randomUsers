import 'package:flutter/material.dart';
import 'package:random_users/extensions/parser.dart';

class ThemeStyle {
  static get theme {
    return ThemeData(
      fontFamily: "SFPRoDisplay",
      textTheme: TextTheme(
          headline1: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 32.dp()),
          bodyText1: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14.dp()),
          subtitle1: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 16.dp()),
          button: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18.dp())),
      buttonColor: Colors.green,
    );
  }
  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };

    return Colors.green[500] ?? Colors.green;
  }
}