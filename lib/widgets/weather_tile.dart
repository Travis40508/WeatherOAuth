import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/utils/constants.dart';
import 'package:weather_oauth/utils/size_config.dart';
import 'package:weather_oauth/widgets/temperature_tile.dart';

class WeatherTile extends StatefulWidget {

  final LocalForecast forecast;
  final VoidCallback onLongPress;

  WeatherTile(this.forecast, this.onLongPress);

  @override
  _WeatherTileState createState() => _WeatherTileState();
}

class _WeatherTileState extends State<WeatherTile> {

  WeatherBloc _bloc;

  @override
  void didChangeDependencies() {
    if (_bloc == null) {
      _bloc = BlocProvider.of<WeatherBloc>(context);
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: this.widget.onLongPress,
      child: FlipCard(
        front: Card(
          color: Theme.of(context).appBarTheme.color,
          elevation: Constants.defaultElevation,
          child: ListTile(
            leading: CachedNetworkImage(
              imageUrl: _bloc?.fetchWeatherIconUrl(widget.forecast.icon),
              color: widget.forecast?.icon != null ? Theme.of(context).secondaryHeaderColor : null,
            ),
            title: Text(
                '${widget.forecast?.locationName}, ${widget.forecast?.country}'
            ),
            subtitle: Text(
                widget.forecast?.description
            ),
            trailing: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                _bloc.kelvinToFahrenheit(widget.forecast?.currentTemp),
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
          ),
        ),
        back: Card(
          color: Theme.of(context).appBarTheme.color,
          elevation: Constants.defaultElevation,
          child: Container(
            height: Constants.defaultLoadingTileHeight,
            width: SizeConfig.getPercentageOfScreenWidth(Constants.defaultLoadingTileWidthPercentage, context),
            child: Row(
              children: <Widget>[
                TemperatureTile(_bloc.kelvinToFahrenheit(widget.forecast.maxTemp), Colors.red),
                TemperatureTile(_bloc.kelvinToFahrenheit(widget.forecast.minTemp), Colors.lightBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
