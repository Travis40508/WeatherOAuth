import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/login_bloc.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';

class LoginTile extends StatefulWidget {
  @override
  _LoginTileState createState() => _LoginTileState();
}

class _LoginTileState extends State<LoginTile> {

  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                onTap: () => _bloc?.authenticateUser(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
