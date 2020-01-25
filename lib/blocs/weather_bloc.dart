

import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_oauth/services/repository.dart';

class WeatherBloc extends Bloc {

  final Repository _repository;
  final _forecastsSubject = BehaviorSubject

  WeatherBloc(this._repository);

  @override
  void dispose() {
    // TODO: implement dispose
  }

}