import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/login_bloc.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';

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
      Navigator.of(context).pushReplacementNamed(WeatherRoute.routeName, arguments: WeatherRoute(displayName));
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: Constants.sunHeroTag,
              child: Icon(
                Icons.wb_sunny,
                size: SizeConfig.getHalfWidthOfScreen(context),
              ),
            ),
            Card(
              elevation: Constants.defaultElevation,
              color: Theme.of(context).appBarTheme.color,
              child: Container(
                width: SizeConfig.getHalfWidthOfScreen(context),
                height: SizeConfig.getPercentageOfScreenHeight(10, context),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(Constants.defaultPadding),
                        child: Icon(Icons.lock),
                      ),
                      Text(
                        Constants.loginWithGoogle,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ],
                  ),
                  onTap: () => _bloc.authenticateUser(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
