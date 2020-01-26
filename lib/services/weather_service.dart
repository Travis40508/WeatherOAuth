

import 'package:weather_oauth/models/location_current_forecast_res.dart';

abstract class WeatherService {
  ///Calls the OpenWeather API to fetch weather for a location of choosing
  Future<LocationCurrentForecastRes> fetchWeatherForLocation(final String location);
}