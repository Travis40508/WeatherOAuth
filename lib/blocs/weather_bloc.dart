

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/services/repository.dart';

class WeatherBloc extends Bloc {

  final Repository _repository;

  final _forecastsSubject = BehaviorSubject<List<LocalForecast>>();
  Stream<List<LocalForecast>> get forecastsStream => _forecastsSubject.stream;

  WeatherBloc(this._repository);

  @override
  void dispose() {
    _forecastsSubject.close();
  }

  void fetchForecastForLocation(final String location) {
    _repository.fetchWeatherDataForLocation(location).listen((forecast) {
      List<LocalForecast> forecasts = _forecastsSubject.value ?? List();
      forecasts?.add(forecast);
      _forecastsSubject.add(forecasts);
    }, onError: (e) {
      print('WeatherBloc - $e');
      _forecastsSubject.addError(e);
    });
  }

  void fetchAllForecastsForUser() {
    _repository.fetchAllWeatherData().listen((forecasts) {
      if (forecasts != null && forecasts.isNotEmpty) {
        _forecastsSubject.add(forecasts);
      } else {
        _forecastsSubject.addError('No locations available');
      }
    }, onError: (e) {
      print('WeatherBloc.fetchAllForecastsForUser() -. $e');
      _forecastsSubject.addError(e);
    });
  }

  void removeLocation(final String location) {
    _repository.removeLocation(location)
    .listen((success) {
      if (success) {
        List<LocalForecast> forecasts = _forecastsSubject?.value;
        forecasts?.removeWhere((forecast) => forecast.locationName == location);
        _forecastsSubject.add(forecasts);
      }
    }, onError: (e) {
      print('WeatherBloc.removeLocation() - $e');
    });
  }
}