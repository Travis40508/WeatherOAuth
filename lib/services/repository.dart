


import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';

abstract class Repository {

  Stream<String> authenticateUser(final bool signInSilently);
  Stream<LocalForecast> fetchWeatherDataForLocation(final String location);
  Stream<List<LocalForecast>> fetchAllWeatherData();
  Stream<bool> removeLocation(final String location);
  Stream<bool> saveNewLocation(final String location);
}