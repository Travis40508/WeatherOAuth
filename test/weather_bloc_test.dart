import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';
import 'package:weather_oauth/services/repository.dart';

import 'mocks/mock_data.dart';
import 'mocks/mock_repository.dart';


void main() {

  Repository _repository;
  WeatherBloc _bloc;

  setUp(() {
    _repository = MockRepository();
    _bloc = WeatherBloc(_repository);
  });

  group('modifying saved locations', () {
    test('adding new place successfully when there are existing forecasts', () {
      final location = 'foo';
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(4);
      final LocalForecast foreCastForFoo = MockData.getMockLocalForecast();

      when(_repository.fetchAllWeatherData()).thenAnswer((_) => Stream.value(forecasts));

      when(_repository.fetchWeatherDataForLocation(location)).thenAnswer((_) => Stream.value(foreCastForFoo));

      List newForecasts = List();
      newForecasts.addAll(forecasts);
      newForecasts.add(foreCastForFoo);

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
        emits(newForecasts)
      ]));

      _bloc.fetchAllForecastsForUser();
      _bloc.fetchForecastForLocation(location);
    });

    test('adding new place successfully when there are no existing forecasts', () {
      final location = 'foo';
      final LocalForecast foreCastForFoo = MockData.getMockLocalForecast();
      final List<LocalForecast> forecasts = List();

      when(_repository.fetchAllWeatherData()).thenAnswer((_) => Stream.value(forecasts));

      when(_repository.fetchWeatherDataForLocation(location)).thenAnswer((_) => Stream.value(foreCastForFoo));

      List newForecasts = List();
      newForecasts.addAll(forecasts);
      newForecasts.add(foreCastForFoo);

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
        emits(newForecasts)
      ]));

      _bloc.fetchAllForecastsForUser();
      _bloc.fetchForecastForLocation(location);
    });

    test('deleting place successfully', () {
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(4);
      final String locationToDelete = forecasts[2]?.locationName;

      when(_repository.fetchAllWeatherData()).thenAnswer((_) => Stream.value(forecasts));
      when(_repository.removeLocation(locationToDelete)).thenAnswer((_) => Stream.value(true));

      List<LocalForecast> newForecasts = List();
      newForecasts.addAll(forecasts);

      newForecasts.removeWhere((forecast) => forecast.locationName == locationToDelete);

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
        emits(newForecasts)
      ]));

      _bloc.fetchAllForecastsForUser();
      _bloc.removeLocation(locationToDelete);
    });

    test('checking all locations and there are not any', () {

    });

    test('stopping user from adding more than 5 places successfully', () {

    });

    test('stopping user from adding a duplicate location successfully', () {

    });
  });

  group('search', () {
    test('not finding searched location', () {

    });

    test('searching for blank location', () {

    });
  });

  group('save functionality', () {
    test('getting 5 local forecasts if there are 5 items in shared preferences on first load', () {

    });

    test('show no locations text on launch if shared pref size is 0', () {

    });

    test('show no locations text on removing of location if shared pref size is 0', () {

    });
  });
}