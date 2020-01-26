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

  final _signOutSubject = PublishSubject<bool>();
  Stream<bool> get signOutStream => _signOutSubject.stream;

  WeatherBloc(this._repository);

  @override
  void dispose() {
    _forecastsSubject.close();
    _errorSubject.close();
    _loadingSubject.close();
    _signOutSubject.close();
  }

  ///full unit-test coverage for this function can be found in weather_bloc_test.dart file
  void fetchForecastForLocation(final String userEmail, final String location) {
    _loadingSubject.add(true);
    if (location == null || location.isEmpty) {
      handleNoSearchTextScenario();
    } else if (_forecastsSubject.value == null || (_forecastsSubject.value.length < 5 && !locationAlreadyExists(location))) {
      attemptToAddLocation(userEmail, location);
    } else if (locationAlreadyExists(location)) {
      handlelDuplicateLocationScenario(location);
    } else {
      handleTooManyLocationsScenario();
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

  ///Fires if the user attempts to search without text in the TextField
  void handleNoSearchTextScenario() {
    _loadingSubject.add(false);
    _errorSubject.add("Please add search criteria.");
  }

  ///Attempts to add a location - throwing an exception if it fails because the location isn't found
  void attemptToAddLocation(final String userEmail, final String location) {
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
  }

  ///Fires if the user attempts to add a location that they have already added
  void handlelDuplicateLocationScenario(final String location) {
    _loadingSubject.add(false);
    _errorSubject.add("You have already added $location. Please add a unique location.");
  }

  ///Fires if the user attemps to add a location after they've already added 5
  void handleTooManyLocationsScenario() {
    _loadingSubject.add(false);
    _errorSubject.add("You already have 5 locations. Please remove one before trying to add another");
  }

  ///Signs user out of the app, informing the _signOutSubject once it's finished.
  void signUserOut() {
    _repository.signUserOut();
    _signOutSubject.add(true);
  }
}