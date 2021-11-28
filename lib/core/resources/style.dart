import 'package:flutter/material.dart';

class ThemeStyle {
  static get theme {
    return ThemeData(
      fontFamily: "SFPRoDisplay",
      textTheme: TextTheme(
          headline1: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 32),
          bodyText1: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black,
              fontSize: 14),
          subtitle1: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontSize: 16),
          button: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18)),
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