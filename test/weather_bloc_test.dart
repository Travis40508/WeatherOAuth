import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';
import 'package:weather_oauth/services/repository.dart';

import 'mocks/mock_repository.dart';


void main() {

  Repository _repository;
  WeatherBloc _bloc;

  setUp(() {
    _repository = MockRepository();
    _bloc = WeatherBloc(_repository);
  });

  group('modifying saved locations', () {
    test('adding new place successfully', () {
      final location = 'foo';
      final LocationCurrentForecastRes res = LocationCurrentForecastRes.fromJson(Map());

      when(_repository.fetchWeatherData(location)).thenAnswer((_) => Stream.value(res));

      expectLater(_bloc.forecastsStream, emits(res));
    });

    test('deleting place successfully', () {

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