


import 'package:weather_oauth/models/google_user.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/models/location_current_forecast_res.dart';

abstract class Repository {

  Stream<GoogleUser> authenticateUser(final bool signInSilently);
  Stream<LocalForecast> fetchWeatherDataForLocation(final String userEmail, String location);
  Stream<List<LocalForecast>> fetchAllWeatherData(final String userEmail);
  Future<bool> removeLocation(final String userEmail, final String location);
  void saveNewLocation(final String userEmail, final String location);
}