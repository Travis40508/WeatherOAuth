import 'package:flutter/material.dart';
import 'package:weather_oauth/routing/weather_route.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  WeatherRoute _route;

  @override
  void didChangeDependencies() {
    _route = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
            _route.displayName,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}