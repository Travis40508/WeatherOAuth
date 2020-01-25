import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/splash_bloc.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';

class SplashTile extends StatefulWidget {
  @override
  _SplashTileState createState() => _SplashTileState();
}

class _SplashTileState extends State<SplashTile> {

  SplashBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<SplashBloc>(context);
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
                  style: Theme.of(context).textTheme?.subtitle,
                  textAlign: TextAlign.center,
                ) : Container();
              },
            ),
          )
        ],
      ),
    );
  }
}
