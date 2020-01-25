
///Electing to use only Dart types for this object, instead of passing in the Weather or WeatherSystem objects
///This will make mocking data for testing much easier

class LocalForecast {
  final String _description;
  final String _icon;
  final double _currentTemp;
  final double _minTemp;
  final double _maxTemp;
  final String _country;
  final String _locationName;

  LocalForecast(this._description, this._icon, this._currentTemp, this._minTemp, this._maxTemp, this._country, this._locationName);

  String get locationName => _locationName;

  String get country => _country;

  double get maxTemp => _maxTemp;

  double get minTemp => _minTemp;

  double get currentTemp => _currentTemp;

  String get icon => _icon;

  String get description => _description;


}