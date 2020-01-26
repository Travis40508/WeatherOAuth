import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/routing/weather_route.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  WeatherRoute _route;
  WeatherBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<WeatherBloc>(context);
    _route = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
            _route.googleUser.displayName,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}
