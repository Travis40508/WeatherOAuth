import 'package:flutter/material.dart';
import 'package:weather_oauth/models/location_current_forecast.dart';

class CurrentForecastForLocationTile extends StatefulWidget {

  final Weather _weather;
  final Temperatures _temperatures;
  final String _country;
  final String _locationName;

  CurrentForecastForLocationTile(this._weather, this._temperatures, this._country, this._locationName);

  @override
  _CurrentForecastForLocationTileState createState() => _CurrentForecastForLocationTileState();
}

class _CurrentForecastForLocationTileState extends State<CurrentForecastForLocationTile> {

  @override
  Widget build(BuildContext context) {
    return Text(widget._locationName);
  }
}
