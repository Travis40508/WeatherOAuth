import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/routing/login_route.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';
import 'package:weather_oauth/widgets/custom_dialog.dart';
import 'package:weather_oauth/widgets/custom_loading_tile.dart';
import 'package:weather_oauth/widgets/no_forecasts_tile.dart';
import 'package:weather_oauth/widgets/search_tile.dart';
import 'package:weather_oauth/widgets/weather_tile.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  WeatherRoute _route;
  WeatherBloc _bloc;

  @override
  void didChangeDependencies() {
    _route = ModalRoute.of(context).settings.arguments;

    if (_bloc == null) {
      _bloc = BlocProvider.of<WeatherBloc>(context);
      _bloc?.fetchAllForecastsForUser(_route?.googleUser?.email);

      observeNavigationEvents();
    }

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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.person,
            color: Theme.of(context).iconTheme.color,),
            onPressed: () {
              showDialog(context: context, builder: (context) => CustomDialog(
                Constants.signingOffTitle,
                Constants.signingOffMessage,
                  () {
                    Navigator.pop(context);
                    _bloc?.signUserOut();
                  },
                  negativeCallback: () => Navigator.pop(context),
              ));
            },
          ),
        ],
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: Hero(
                tag: Constants.sunHeroTag,
                child: Icon(
                    Icons.wb_sunny,
                    size: SizeConfig.getPercentageOfScreenHeight(6, context),
                    color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
            Expanded(
              child: Text(
                  '${Constants.forecastForPrefix} ${_route?.googleUser?.displayName}',
                style: Theme.of(context).textTheme.subhead,
                overflow: TextOverflow.clip,
              ),
            )
          ],
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(Constants.defaultPadding),
              child: SearchTile()
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  StreamBuilder(
                    stream: _bloc.forecastsStream,
                    builder: (context, AsyncSnapshot<List<LocalForecast>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot?.data?.length,
                          itemBuilder: (context, index) {
                            LocalForecast forecast = snapshot?.data[index];
                            return WeatherTile(forecast, () {
                              handleOnLongClick(forecast);
                            });
                          },
                        );
                      }

                      return NoForecastsTile();
                    },
                  ),
                  StreamBuilder(
                    stream: _bloc?.loadingStream,
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
            )
          ],
        ),
      ),
    );
  }

  void observeNavigationEvents() {
    _bloc?.errorStream?.listen((errorMessage) {
      showDialog(context: context, builder: (_) => CustomDialog(Constants.failureDialogTitle, errorMessage, () => Navigator.pop(context)));
    }, onError: (e) => print(e));

    _bloc?.signOutStream?.listen((signingOut) {
      Navigator.pushReplacementNamed(context, LoginRoute.routeName, arguments: LoginRoute());
    }, onError: (e) => print(e));
  }

  void handleOnLongClick(final LocalForecast forecast) {
    showDialog(context: context, builder: (_) => CustomDialog(
        '${Constants.deletingText} ${forecast.locationName}',
        Constants.deletionConfirmation,
            () {
              _bloc?.removeLocation(_route?.googleUser?.email, forecast?.locationName);
              Navigator.pop(context);
            }
      , negativeCallback: () => Navigator.pop(context),));
  }
}
