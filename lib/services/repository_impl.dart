

import 'package:weather_oauth/models/google_user.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';
import 'package:weather_oauth/services/authentication_service.dart';
import 'package:weather_oauth/services/authentication_service_impl.dart';
import 'package:weather_oauth/services/repository.dart';

class RepositoryImpl implements Repository {

  final AuthenticationService _authService = AuthenticationServiceImpl();

  @override
  Stream<GoogleUser> authenticateUser(final bool signInSilently) {
    return Stream.fromFuture(_authService.fetchGoogleAuthentication(signInSilently))
        .map((authentication) => authentication?.user)
        .map((user) => GoogleUser(user?.displayName, user?.email));
  }

  @override
  Stream<LocalForecast> fetchWeatherDataForLocation(String location) {
    // TODO: implement fetchWeatherData
    throw UnimplementedError();
  }

  @override
  Stream<bool> removeLocation(String location) {
    // TODO: implement removeLocation
    throw UnimplementedError();
  }

  @override
  Stream<List<LocalForecast>> fetchAllWeatherData() {
    // TODO: implement fetchAllWeatherData
    throw UnimplementedError();
  }

  @override
  Stream<bool> saveNewLocation(String location) {
    // TODO: implement saveNewLocation
    throw UnimplementedError();
  }

}