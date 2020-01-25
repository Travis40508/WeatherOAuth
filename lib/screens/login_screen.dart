import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/login_bloc.dart';
import 'package:weather_oauth/routing/weather_route.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BlocProvider.of<LoginBloc>(context);

    _bloc.authResultStream.listen((displayName) {
      Navigator.of(context).pushNamed(WeatherRoute.routeName, arguments: WeatherRoute(displayName));
    }, onError: (e) => print(e));
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        title: Text(
          'OAuth!',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white
            ),
          ),
          color: Colors.blueAccent,
          onPressed: () => _bloc.authenticateUser(),
        ),
      ),
    );
  }
}
