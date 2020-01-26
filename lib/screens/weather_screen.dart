import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';
import 'package:weather_oauth/widgets/custom_dialog.dart';
import 'package:weather_oauth/widgets/no_forecasts_tile.dart';
import 'package:weather_oauth/widgets/search_tile.dart';

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
      _bloc.fetchAllForecastsForUser(_route.googleUser.email);

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
            Text(
                'Forecasts for ${_route.googleUser.displayName}',
              style: Theme.of(context).textTheme.subhead,
            )
          ],
        )
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchTile()
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  StreamBuilder(
                    stream: _bloc.loadingStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      if (snapshot.data) {
                        return Center(
                            child: Card(
                              color: Theme.of(context).appBarTheme.color,
                              elevation: Constants.defaultElevation,
                              child: Container(
                                height: Constants.defaultLoadingTileHeight,
                                width: SizeConfig.getPercentageOfScreenWidth(Constants.defaultLoadingTileWidthPercentage, context),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ),
                        );
                      }

                      return Container();
                    },
                  ),
                  StreamBuilder(
                    stream: _bloc.forecastsStream,
                    builder: (context, AsyncSnapshot<List<LocalForecast>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return RaisedButton(
                              child: Text(
                                snapshot.data[index].locationName
                              ),
                              onPressed: () => _bloc.removeLocation(_route.googleUser.email, snapshot.data[index].locationName),
                            );
                          },
                        );
                      }

                      return NoForecastsTile();
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
    _bloc.errorStream.listen((errorMessage) {
      showDialog(context: context, builder: (_) => CustomDialog('Bummer', errorMessage, () => Navigator.pop(context)));
    }, onError: (e) => print(e));
  }
}
