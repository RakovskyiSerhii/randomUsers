import 'package:random_users/resources/dimen.dart';

extension DoubleParser on double {
  double dp() {
    return Dimen.pixelsScaleFactor * this;
  }

  double sp() {
    var result = Dimen.fontScaleFactor * this;
    if (result < 10) {
      return 10;
    }

    return result;
  }
}

extension IntParser on int {
  double dp() {
    return Dimen.pixelsScaleFactor * this;
  }

  double sp() {
    var result = Dimen.fontScaleFactor * this;
    if (result < 10) {
      return 10;
    }
    return result;
  }

  String formatPoints() {
    String formatted = (this.toDouble() / 100).toString().replaceAll(",", ".");

    if ((formatted.length - formatted.lastIndexOf(".")) == 2) {
      formatted += "0";
    }

    return formatted.replaceAll('.00', '');
  }
}