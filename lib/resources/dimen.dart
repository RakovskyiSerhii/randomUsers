import 'dart:math';

import 'package:flutter/cupertino.dart';

class Dimen {
  ///after hundred hours of testing, original scale value
  ///defined! it`s == 400dp.
  ///all other screen sizes scaling according to this value
  static const ORIGINAL_PIXEL_RATIO = 400.0;
  static double pixelsScaleFactor = 1;
  static double fontScaleFactor = 1;

  /// for the base value taken design screen width (375 px)
  ///
  /// mapItemsScaleFactor = (currentScreenWidth) / 375 px
  ///
  /// Each map item image size (markers, clusters) should be multiplied
  /// on this value to looks same size for all screen sizes.
  ///
  /// tested on
  /// Galaxy s9+, nexus one, nexus 5x, 2K 10 inch screen tablet
  /// works perfect!!
  static double mapItemsScaleFactor = 1;

  static init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double swpd = min(size.width, size.height);
    double scaleFactor = swpd / ORIGINAL_PIXEL_RATIO;

    mapItemsScaleFactor =
        (size.width * MediaQuery.of(context).devicePixelRatio) / 375;

    mapItemsScaleFactor = min(3.75, mapItemsScaleFactor) * 0.95; //so hard logic, dont ask me why.

    if (scaleFactor > 2) {
      scaleFactor = 1.75;
    } else if (scaleFactor > 1.5) {
      scaleFactor = 1.5;
    }

    fontScaleFactor = scaleFactor;
    pixelsScaleFactor = scaleFactor;
  }

  static double swdp(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return min(size.width, size.height);
  }
}
