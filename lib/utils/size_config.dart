
import 'package:flutter/cupertino.dart';

class SizeConfig {

  ///this could be replaced with getPercentageOfScreenWidth
  ///however, for a dev just wanting a very general, usually pretty good-looking ratio, this is it
  static double getHalfWidthOfScreen(final BuildContext context) {
    return MediaQuery.of(context).size.width / 2;
  }

  static double getPercentageOfScreenWidth(final int percentage, final BuildContext context) {
    return MediaQuery.of(context).size.width / (100 / percentage);
  }

  static double getPercentageOfScreenHeight(final int percentage, final BuildContext context) {
    return MediaQuery.of(context).size.height / (100 / percentage);
  }
}