import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/splash_bloc.dart';
import 'package:weather_oauth/routing/login_route.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<SplashBloc>(context);
    _bloc.fetchFirebaseToken();

    listenForNavigation();
    super.didChangeDependencies();
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
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            Text(
                Constants.appTitle,
              style: Theme.of(context).textTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: StreamBuilder(
                stream: _bloc.displayNameStream,
                builder: (context, AsyncSnapshot<String> snapshot) {
                  return snapshot.hasData ? Text(
                      _bloc?.fetchGreeting(snapshot?.data),
                    style: Theme.of(context).textTheme.subtitle,
                    textAlign: TextAlign.center,
                  ) : Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void listenForNavigation() {
    _bloc.displayNameStream
        .debounce((_) => TimerStream(true, Duration(seconds: Constants.splashWaitDurationInSeconds)))
        .listen((displayName) {
          Navigator.of(context).pushReplacementNamed(LoginRoute.routeName, arguments: LoginRoute());
//      Navigator.of(context).pushReplacementNamed(WeatherRoute.routeName, arguments: WeatherRoute(displayName));
    }, onError: (e) {
      ///it's good practice to use an empty route object to enforce consistent behavior for navigation
      ///this will ensure that later on we don't go to a screen without necessary data
      Future.delayed(Duration(seconds: Constants.splashWaitDurationInSeconds), () {
        Navigator.of(context).pushReplacementNamed(LoginRoute.routeName, arguments: LoginRoute());
      });
    });
  }
}
