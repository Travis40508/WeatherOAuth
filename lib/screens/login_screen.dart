import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/login_bloc.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:weather_oauth/widgets/custom_loading_tile.dart';
import 'package:weather_oauth/widgets/login_tile.dart';

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

    _bloc.authResultStream.listen((user) {
      Navigator.of(context).pushReplacementNamed(WeatherRoute.routeName, arguments: WeatherRoute(user));
    }, onError: (e) => print(e));
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          LoginTile(),
          StreamBuilder(
            stream: _bloc.loadingStream,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data) {
                return CustomLoadingTile();
              }

              return Container();
            },
          ),
        ],
      ),
    );
  }
}
