
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_oauth/models/google_user.dart';
import 'package:weather_oauth/services/repository.dart';

class LoginBloc extends Bloc {

  final Repository _repository;

  final _authResultSubject = PublishSubject<GoogleUser>();
  Stream<GoogleUser> get authResultStream => _authResultSubject.stream;

  LoginBloc(this._repository);

  @override
  void dispose() {
    _authResultSubject.close();
  }

  void authenticateUser() {
    _repository.authenticateUser(false).listen((user) {
      print('Successful login with user - $user');
      _authResultSubject.add(user);
    }, onError: (e) {
      print('LoginBloc $e');
      _authResultSubject.addError(e);
    });

  }

}