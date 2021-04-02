import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


extension StateExtensions on State {

  void showNoConnectionPopup() {

  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode()); //hide keyboard
  }
  void changeStatusBarColor(int color) {
     if (Platform.isAndroid) MethodChannel('ua.dafi/flutter').invokeMethod('statusbar_color', {
      'colorKey': color,
    });
  }
}
