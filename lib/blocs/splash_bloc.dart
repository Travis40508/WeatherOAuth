
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_oauth/services/repository.dart';

class SplashBloc extends Bloc {

  final Repository _repository;

  final _displayNameSubject = PublishSubject<String>();
  Stream<String> get displayNameStream => _displayNameSubject.stream;

  SplashBloc(this._repository);


  void fetchFirebaseToken() {
    _repository.authenticateUser().listen((displayName) {
      if (displayName.isNotEmpty) {
        _displayNameSubject.add(displayName);
      } else {
        _displayNameSubject.addError('displayName shouldn\nt be empty');
      }
    }, onError: (e) {
      print('SplashBloc.fetchFirebaseToken - $e');
      _displayNameSubject.addError(e);
    });
  }

  @override
  void dispose() {
    _displayNameSubject.close();
  }

}