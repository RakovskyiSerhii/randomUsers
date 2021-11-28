import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class Drawables {
  static const String IMAGES_PATH = "assets/images/";
  static const String PNG = ".png";
  static const String SVG = ".svg";

  static const String NETWORK_CONNECTIONS = "ic_connection.svg";


  static SvgPicture? getSizedSvg(String name, double width, double height) {
    return name.isEmpty
        ? null
        : SvgPicture.asset(
      IMAGES_PATH + name,
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
  }

  static SvgPicture? getSvg(String name, {Color? tint}) {
    return name.isEmpty
        ? null
        : SvgPicture.asset(
      IMAGES_PATH + name,
      color: tint,
    );
  }

  // return png picture, depend on current device screen scale factor
  // e.g. for device with scale factor 2.7 will return image from folder
  // images/3.0x/name
  static Image? getPng(String name, {Color? tint}) {
    return name.isEmpty ? null : Image.asset(IMAGES_PATH + name, color: tint);
  }

  static Widget? getImage(String name, {Color? tint}) {
    if (name.endsWith(PNG)) {
      return getPng(name, tint: tint);
    } else {
      return getSvg(name, tint: tint);
    }
  }

  static Widget getSizedImage(String name, double width, double height,
      {Color? tint}) {
    return Container(
        width: width,
        height: height,
        child: name.endsWith(PNG)
            ? getPng(name, tint: tint)
            : getSvg(name, tint: tint));
  }
}