import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/services/repository.dart';
import 'package:weather_oauth/utils/constants.dart';

class WeatherBloc extends Bloc {

  final Repository _repository;

  final _forecastsSubject = BehaviorSubject<List<LocalForecast>>();
  Stream<List<LocalForecast>> get forecastsStream => _forecastsSubject.stream;

  final _errorSubject = PublishSubject<String>();
  Stream<String> get errorStream => _errorSubject.stream;

  final _loadingSubject = PublishSubject<bool>();
  Stream<bool> get loadingStream => _loadingSubject.stream;

  WeatherBloc(this._repository);

  @override
  void dispose() {
    _forecastsSubject.close();
    _errorSubject.close();
    _loadingSubject.close();
  }

  ///full unit-test coverage for this function can be found in weather_bloc_test.dart file
  void fetchForecastForLocation(final String userEmail, final String location) {
    _loadingSubject.add(true);
    if (location == null || location.isEmpty) {
      _errorSubject.add("Please add search criteria.");
    } else if (_forecastsSubject.value == null || (_forecastsSubject.value.length < 5 && !locationAlreadyExists(location))) {
      _repository.fetchWeatherDataForLocation(userEmail, location).listen((forecast) {
        List<LocalForecast> forecasts = _forecastsSubject.value ?? List();
          forecasts?.add(forecast);
          _loadingSubject.add(false);
          _forecastsSubject.add(forecasts);
      }, onError: (e) {
        print('WeatherBloc - $e');
        _loadingSubject.add(false);
        _errorSubject.add("No location found. Please try again");
      });
    } else if (locationAlreadyExists(location)) {
      _errorSubject.add("You have already added $location. Please add a unique location.");
    } else {
      _errorSubject.add("You already have 5 locations. Please remove one before trying to add another");
    }
  }

  bool locationAlreadyExists(final String locationName) {
    bool alreadyExists = false;
    if (_forecastsSubject.value != null) {
      int indexOfIdenticalItem = _forecastsSubject.value.indexWhere((forecast) => forecast.locationName.toLowerCase() == locationName.toLowerCase());
      alreadyExists = indexOfIdenticalItem >= 0;
    }

    return alreadyExists;
  }

  void fetchAllForecastsForUser(final String userEmail) async {
    _loadingSubject.add(true);
    _repository.fetchAllWeatherData(userEmail).listen((forecasts) {
      if (forecasts != null && forecasts.isNotEmpty) {
        _forecastsSubject.add(forecasts);
      } else {
        _forecastsSubject.addError('No locations available');
      }
      _loadingSubject.add(false);
    }, onError: (e) {
      print('WeatherBloc.fetchAllForecastsForUser() -. $e');
      _loadingSubject.add(false);
      _forecastsSubject.addError(e);
    });
  }

  void removeLocation(final String userEmail, final String location) async {
    bool successfullyRemoved = await _repository.removeLocation(userEmail, location);
      if (successfullyRemoved) {
        List<LocalForecast> forecasts = _forecastsSubject?.value;
        forecasts?.removeWhere((forecast) => forecast.locationName == location);

        ///clearing the stream
        _forecastsSubject.add(forecasts.isNotEmpty ? forecasts : null);
      }
  }

  void saveLocation(final String location) {

  }

  String fetchWeatherIconUrl(String icon) {
    return icon != null && icon.isNotEmpty ? '${Constants.iconPrefix}$icon${Constants.iconSuffix}' : Constants.noImageAvailableUrl;
  }

  String kelvinToFahrenheit(final dynamic kelvin) {
    return '${((kelvin - 273) * (9/5) + 32).toInt()}${Constants.degreeSymbol}';
  }
}