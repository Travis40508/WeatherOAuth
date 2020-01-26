import 'package:shared_preferences/shared_preferences.dart';
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
    return Stream.fromFuture(
            _authService.fetchGoogleAuthentication(signInSilently))
        .map((authentication) => authentication?.user)
        .map((user) => GoogleUser(user?.displayName, user?.email));
  }

  @override
  Stream<LocalForecast> fetchWeatherDataForLocation(final String userEmail, final String location, {final bool saveLocation = true}) {
    return Stream.fromFuture(_weatherService.fetchWeatherForLocation(location))
        .map((res) => LocalForecast(
            res.weatherList.first.description,
            res.weatherList.first.icon,
            res.temperatures.currentTemperature,
            res.temperatures.lowTemperature,
            res.temperatures.highTemperature,
            res.weatherSystem.country,
            res.locationName))
        .doOnData((forecast) => saveLocation ? saveNewLocation(userEmail, location) : print('location not saved'));
  }

  @override
  Future<bool> removeLocation(final String userEmail, final String location) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> savedLocations = sharedPreferences.getStringList(userEmail) ?? List();
    savedLocations.remove(location);

    return sharedPreferences.setStringList(userEmail, savedLocations);
  }

  @override
  Stream<List<LocalForecast>> fetchAllWeatherData(final String userEmail) {
    return Stream.fromFuture(SharedPreferences.getInstance())
        .map((prefs) => prefs.getStringList(userEmail))
        .flatMapIterable((list) => Stream.value(list))
        .flatMap((savedLocation) => fetchWeatherDataForLocation(userEmail, savedLocation, saveLocation: false))
        .toList()
        .asStream();
  }

  @override
  void saveNewLocation(final String userEmail, final String location) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> savedLocations = sharedPreferences.getStringList(userEmail) ?? List();
    savedLocations.add(location);

    sharedPreferences.setStringList(userEmail, savedLocations);
  }
}
