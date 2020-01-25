

import 'dart:math';

import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';

class MockData {

  static LocalForecast getMockLocalForecast() {
    LocalForecast localForecast = LocalForecast(Weather.fromJson(Map()), Temperatures.fromJson(Map()), Random().nextInt(100).toString(), Random().nextInt(100).toString());

    return localForecast;
  }

  static List<LocalForecast> getMockLocalForecastList(final int size) {
    List<LocalForecast> forecasts = List();

    for (int i = 0; i < size; i++) {
      forecasts.add(getMockLocalForecast());
    }

    return forecasts;
  }
}