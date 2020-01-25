
import 'location_current_forecast.dart';

class LocalForecast {
  final Weather _weather;
  final Temperatures _temperatures;
  final String _country;
  final String _locationName;

  LocalForecast(this._weather, this._temperatures, this._country, this._locationName);
}