
///Electing to use only Dart types for this object, instead of passing in the Weather or WeatherSystem objects
///This will make mocking data for testing much easier

class LocalForecast {
  final String _description;
  final String _icon;
  final dynamic _currentTemp;
  final dynamic _minTemp;
  final dynamic _maxTemp;
  final String _country;
  final String _locationName;

  LocalForecast(this._description, this._icon, this._currentTemp, this._minTemp, this._maxTemp, this._country, this._locationName);

  String get locationName => _locationName;

  String get country => _country;

  dynamic get maxTemp => _maxTemp;

  dynamic get minTemp => _minTemp;

  dynamic get currentTemp => _currentTemp;

  String get icon => _icon;

  String get description => _description;


}