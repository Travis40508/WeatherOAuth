
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/login_bloc.dart';
import 'package:weather_oauth/blocs/splash_bloc.dart';
import 'package:weather_oauth/routing/login_route.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:weather_oauth/screens/login_screen.dart';
import 'package:weather_oauth/screens/splash_screen.dart';
import 'package:weather_oauth/screens/weather_screen.dart';
import 'package:weather_oauth/services/repository.dart';
import 'package:weather_oauth/services/repository_impl.dart';

class Application extends StatelessWidget {

  ///since this is a small app, we're going to use one instance of our repo class, since Firebase is such an expensive object
  final Repository _repository = RepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather OAuth',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
          bloc: SplashBloc(_repository),
          child: SplashScreen()
      ),
      routes: {
        LoginRoute.routeName : (context) => BlocProvider(
          bloc: LoginBloc(_repository),
          child: LoginScreen(),
        ),
        WeatherRoute.routeName : (context) => WeatherScreen()
      },
    );
  }
}
