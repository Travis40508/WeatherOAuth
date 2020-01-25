
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
import 'package:weather_oauth/utils/constants.dart';

class Application extends StatelessWidget {

  ///since this is a small app, we're going to use one instance of our repo class, since Firebase is such an expensive object
  final Repository _repository = RepositoryImpl();

  final primaryColor = Colors.blueAccent;
  final secondaryColor = Colors.orange[300];
  final appBarColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
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
      theme: ThemeData(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: secondaryColor
        ),
        appBarTheme: AppBarTheme(
          color: appBarColor,
          textTheme: TextTheme(
              title: TextStyle(
                  color: secondaryColor,
                  fontSize: 18.0
              ),
          ),
        ),
        textTheme: TextTheme(
          title: TextStyle(
            color: secondaryColor,
            fontSize: 48.0,
            fontWeight: FontWeight.bold
          ),
          subtitle: TextStyle(
              color: secondaryColor,
              fontSize: 36.0,
              fontWeight: FontWeight.bold
          ),
        )
      ),
    );
  }
}
