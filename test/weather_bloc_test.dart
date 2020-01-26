import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/services/repository.dart';
import 'package:weather_oauth/utils/constants.dart';

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
    test('adding new place successfully when there are existing forecasts', () async {
      final location = 'foo';
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(4);
      final LocalForecast foreCastForFoo = MockData.getMockLocalForecast();

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(forecasts));
      when(_repository.fetchWeatherDataForLocation(MockData.fetchUserEmail(), location)).thenAnswer((_) => Stream.value(foreCastForFoo));

      List newForecasts = List();
      newForecasts.addAll(forecasts);
      newForecasts.add(foreCastForFoo);

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
        emits(newForecasts)
      ]));

      ///warning is invalid - ensures that functions are ran synchronously
      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
      _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), location);
    });

    test('adding new place successfully when there are no existing forecasts', () async {
      final location = 'foo';
      final LocalForecast foreCastForFoo = MockData.getMockLocalForecast();
      final List<LocalForecast> forecasts = List();

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(forecasts));

      when(_repository.fetchWeatherDataForLocation(MockData.fetchUserEmail(), location)).thenAnswer((_) => Stream.value(foreCastForFoo));

      List newForecasts = List();
      newForecasts.addAll(forecasts);
      newForecasts.add(foreCastForFoo);

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emitsError(anything),
        emits(newForecasts)
      ]));

      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
      _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), location);
    });

    test('deleting place successfully', () async {
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(4);
      final String locationToDelete = forecasts[2]?.locationName;

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(forecasts));
      when(_repository.removeLocation(MockData.fetchUserEmail(), locationToDelete)).thenAnswer((_) => Future.value(true));

      List<LocalForecast> newForecasts = List();
      newForecasts.addAll(forecasts);

      newForecasts.removeWhere((forecast) => forecast.locationName == locationToDelete);

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
        emits(newForecasts)
      ]));

      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
      _bloc.removeLocation(MockData.fetchUserEmail(), locationToDelete);
    });

    test('checking all locations and succeeds if there are not any', () {

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(null));

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emitsError(anything)
      ]));

      _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
    });

    test('stopping user from adding more than 5 places successfully', () async {
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(5);
      final LocalForecast forecastToAdd = MockData.getMockLocalForecast();

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(forecasts));

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
      ]));

      expectLater(_bloc.errorStream, emitsInOrder([
        emits(anything)
      ]));

      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
      _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), forecastToAdd.locationName);
    });

    test('stopping user from adding a duplicate location successfully', () async {
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(4);
      final LocalForecast forecastToAdd = forecasts[1];

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(forecasts));

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emits(forecasts),
      ]));

      expectLater(_bloc.errorStream, emitsInOrder([
        emits(anything)
      ]));

      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
      _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), forecastToAdd.locationName);

    });

    test('location already exists', () async {
      final List<LocalForecast> forecasts = MockData.getMockLocalForecastList(4);
      final LocalForecast forecastToAdd = forecasts[1];

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.value(forecasts));

      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
      bool alreadyAdded = _bloc.locationAlreadyExists(forecastToAdd.locationName);

      expect(alreadyAdded, true);
    });

    test('general error scenario for adding location', () async {
      final error = Error();
      final String searchQuery = 'foo';

      when(_repository.fetchWeatherDataForLocation(MockData.fetchUserEmail(), searchQuery)).thenAnswer((_) => Stream.error(error));

      expectLater(_bloc.errorStream, emitsInOrder([
        emits(anything)
      ]));

      await _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), searchQuery);
    });

    test('general error scenario for all locations', () async {
      final error = Error();

      when(_repository.fetchAllWeatherData(MockData.fetchUserEmail())).thenAnswer((_) => Stream.error(error));

      expectLater(_bloc.forecastsStream, emitsInOrder([
        emitsError(error)
      ]));

      await _bloc.fetchAllForecastsForUser(MockData.fetchUserEmail());
    });
  });

  group('search', () {
    test('not finding searched location', () async {
      final String searchQuery = 'as8d7as9d87a9duasd';
      final error = Error();

      when(_repository.fetchWeatherDataForLocation(MockData.fetchUserEmail(), searchQuery)).thenAnswer((_) => Stream.error(error));

      expectLater(_bloc.errorStream, emitsInOrder([
        emits(anything)
      ]));

      _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), searchQuery);
    });

    test('searching for blank location', () {
      final String searchQuery = Constants.empty;

      expectLater(_bloc.errorStream, emitsInOrder([
        emits(anything)
      ]));

      _bloc.fetchForecastForLocation(MockData.fetchUserEmail(), searchQuery);

    });
  });
}