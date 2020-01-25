


import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';

abstract class Repository {

  Stream<String> authenticateUser(final bool signInSilently);
  Stream<List<LocalForecast>> fetchWeatherData(final String location);
}