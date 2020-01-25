
import 'package:flutter/cupertino.dart';

class SizeConfig {

  static double getHalfWidthOfScreen(BuildContext context) {
    return MediaQuery.of(context).size.width / 2;
  }
}