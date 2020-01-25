import 'package:flutter/foundation.dart';

class WeatherRoute {
  static const routeName = "weatherRoute";

  ///make route fail if the user doesn't pass in required information
  WeatherRoute({@required String displayName}) : assert(displayName != null && displayName.isNotEmpty);
}