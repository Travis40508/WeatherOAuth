

import 'dart:math';

import 'package:weather_oauth/models/local_forecast.dart';

class MockData {

  static LocalForecast getMockLocalForecast() {
    LocalForecast localForecast = LocalForecast(
        'fooDesc',
        'fooIcon',
        Random().nextInt(250).toDouble(),
        Random().nextInt(100).toDouble(),
        Random().nextInt(250).toDouble(),
        Random().nextInt(100).toString(),
        Random().nextInt(100).toString());

    return localForecast;
  }

  static List<LocalForecast> getMockLocalForecastList(final int size) {
    List<LocalForecast> forecasts = List();

    for (int i = 0; i < size; i++) {
      forecasts.add(getMockLocalForecast());
    }

    return forecasts;
  }

  static String fetchUserEmail() {
    return 'fooMail@gmail.com';
  }
}