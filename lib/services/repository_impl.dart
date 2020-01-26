

import 'package:weather_oauth/models/google_user.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/services/authentication_service.dart';
import 'package:weather_oauth/services/authentication_service_impl.dart';
import 'package:weather_oauth/services/repository.dart';
import 'package:weather_oauth/services/weather_service.dart';
import 'package:weather_oauth/services/weather_service_impl.dart';
import 'package:rxdart/rxdart.dart';

class RepositoryImpl implements Repository {

  final AuthenticationService _authService = AuthenticationServiceImpl();
  final WeatherService _weatherService = WeatherServiceImpl();

  @override
  Stream<GoogleUser> authenticateUser(final bool signInSilently) {
    return Stream.fromFuture(_authService.fetchGoogleAuthentication(signInSilently))
        .map((authentication) => authentication?.user)
        .map((user) => GoogleUser(user?.displayName, user?.email));
  }

  @override
  Stream<LocalForecast> fetchWeatherDataForLocation(final String location) {
      return Stream.fromFuture(_weatherService.fetchWeatherForLocation(location))
          .map((res) => LocalForecast(
        res.weatherList.first.description,
        res.weatherList.first.icon,
        res.temperatures.currentTemperature,
        res.temperatures.lowTemperature,
        res.temperatures.highTemperature,
        res.weatherSystem.country,
        res.locationName
      ));
  }

  @override
  Stream<bool> removeLocation(final String userEmail, final String location) {
    // TODO: implement removeLocation
    throw UnimplementedError();
  }

  @override
  Stream<List<LocalForecast>> fetchAllWeatherData(final String userEmail) {
    // TODO: implement fetchAllWeatherData
    throw UnimplementedError();
  }

  @override
  Stream<bool> saveNewLocation(final String userEmail, final String location) {
    // TODO: implement saveNewLocation
    throw UnimplementedError();
  }

}