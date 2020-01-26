
class LocationCurrentForecastRes {
  final List<Weather> _weatherList;
  final Temperatures _temperatures;
  final WeatherSystem _weatherSystem;
  final String _locationName;

  LocationCurrentForecastRes.fromJson(Map<String, dynamic> parsedJson)
    : _weatherList = (parsedJson['weather'] as List).map((weather) => Weather.fromJson(weather)).toList(),
      _temperatures = Temperatures.fromJson(parsedJson['main']),
      _weatherSystem = WeatherSystem.fromJson(parsedJson['sys']),
      _locationName = parsedJson['name'];

  String get locationName => _locationName;

  WeatherSystem get weatherSystem => _weatherSystem;

  Temperatures get temperatures => _temperatures;

  List<Weather> get weatherList => _weatherList;

}

class Weather {
  final String _description;
  final String _icon;

  Weather.fromJson(Map<String, dynamic> parsedJson)
    : _description = parsedJson['description'],
      _icon = parsedJson['icon'];

  String get icon => _icon;

  String get description => _description;
}

class Temperatures {
  final dynamic _currentTemperature;
  final dynamic _highTemperature;
  final dynamic _lowTemperature;

  Temperatures.fromJson(Map<String, dynamic> parsedJson)
    : _currentTemperature = parsedJson['temp'],
      _highTemperature = parsedJson['temp_max'],
      _lowTemperature = parsedJson['temp_min'];

  dynamic get lowTemperature => _lowTemperature;

  dynamic get highTemperature => _highTemperature;

  dynamic get currentTemperature => _currentTemperature;

}

class WeatherSystem {
  final String _country;

  WeatherSystem.fromJson(Map<String, dynamic> parsedJson)
    : _country = parsedJson['country'];

  String get country => _country;

}

