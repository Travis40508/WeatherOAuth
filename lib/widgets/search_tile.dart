import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/routing/weather_route.dart';
import 'package:weather_oauth/utils/constants.dart';

class SearchTile extends StatefulWidget {
  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {

  WeatherBloc _bloc;
  WeatherRoute _route;

  TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    _route = ModalRoute.of(context)?.settings?.arguments;

    if (_bloc == null) {
      _bloc = BlocProvider.of<WeatherBloc>(context);
      _bloc.fetchAllForecastsForUser(_route?.googleUser?.email);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (query) {
        _bloc.fetchForecastForLocation(_route.googleUser.email, query);
        _controller?.clear();
      },
      textInputAction: TextInputAction.go,
      style: Theme.of(context).textTheme.subhead,
      cursorColor: Theme.of(context).secondaryHeaderColor,
      controller: _controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).appBarTheme.color,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: Constants.defaultBorderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).secondaryHeaderColor, width: Constants.defaultBorderWidth),
        ),

        labelText: Constants.searchLabel,
        hintText: Constants.searchHint,
        labelStyle: TextStyle(
            color: Theme.of(context).secondaryHeaderColor
        ),
        hintStyle: Theme.of(context).textTheme.subhead,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).iconTheme.color,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          color: Theme.of(context).iconTheme.color,
          onPressed: () => _controller?.clear(),
        ),
      ),
      maxLines: 1,
    );
  }
}
