
class WeatherRoute {
  static const routeName = "weatherRoute";
  final String _displayName;

  ///make route fail if the user doesn't pass in required information
  WeatherRoute(this._displayName);

  String get displayName => _displayName;
}