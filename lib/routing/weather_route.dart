
import 'package:weather_oauth/models/google_user.dart';

class WeatherRoute {
  static const routeName = "weatherRoute";
  final GoogleUser _googleUser;

  ///make route fail if the user doesn't pass in required information
  WeatherRoute(this._googleUser);

  GoogleUser get googleUser => _googleUser;
}