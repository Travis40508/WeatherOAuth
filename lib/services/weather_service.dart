

import 'package:weather_oauth/models/location_current_forecast_res.dart';

abstract class WeatherService {
  Future<LocationCurrentForecastRes> fetchWeatherForLocation(final String location);
}