import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:weather_oauth/blocs/weather_bloc.dart';
import 'package:weather_oauth/models/local_forecast.dart';
import 'package:weather_oauth/routing/weather_route.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  WeatherRoute _route;
  WeatherBloc _bloc;
  TextEditingController _controller = TextEditingController();

  @override
  void didChangeDependencies() {
    _route = ModalRoute.of(context).settings.arguments;

    if (_bloc == null) {
      _bloc = BlocProvider.of<WeatherBloc>(context);
      _bloc.fetchAllForecastsForUser(_route.googleUser.email);
    }

    observeNavigationEvents();
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
            _route.googleUser.displayName,
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
            ),
            RaisedButton(
              child: Text(
                'Search'
              ),
              onPressed: () => _bloc.fetchForecastForLocation(_route.googleUser.email, _controller.text),
            ),
            RaisedButton(
              child: Text(
                'Save'
              ),
              onPressed: () => _bloc.saveLocation(_controller.text),
            ),
            Expanded(
              child: StreamBuilder(
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

                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void observeNavigationEvents() {
    _bloc.errorStream.listen((errorMessage) {
      Dialog errorDialog = Dialog(
        child: Text(
          errorMessage
        ),
      );
      showDialog(context: context, builder: (context) => errorDialog);
    }, onError: (e) => print(e));
  }
}
