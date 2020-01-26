

import 'dart:convert';

import 'package:weather_oauth/models/location_current_forecast_res.dart';
import 'package:weather_oauth/services/weather_service.dart';
import 'package:http/http.dart' show Client;

class WeatherServiceImpl implements WeatherService {

  Client client = Client();
  static const _baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  static const _queryKey = 'q=';
  static const _appIdKey = 'appid=';
  ///I'd normally put this in a .gitignore file; but I didn't want to take away your ability to run this application locally and test
  static const _appId = '022101210e47f1901292b41271e0eead';


  @override
  Future<LocationCurrentForecastRes> fetchWeatherForLocation(final String location) async {
    final url = '$_baseUrl?$_queryKey$location&$_appIdKey$_appId';
    print('fetching response for $url');
    final response = await client.get(url);
    final json = jsonDecode(response.body);

    print('response for $url:');
    print(json);

    return LocationCurrentForecastRes.fromJson(json);
  }

}