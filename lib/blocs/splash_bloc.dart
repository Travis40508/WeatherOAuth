
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_oauth/models/google_user.dart';
import 'package:weather_oauth/services/repository.dart';
import 'package:weather_oauth/utils/constants.dart';

class SplashBloc extends Bloc {

  final Repository _repository;

  final userSubject = PublishSubject<GoogleUser>();
  Stream<GoogleUser> get userStream => userSubject.stream;

  SplashBloc(this._repository);


  void fetchFirebaseToken() {
    _repository.authenticateUser(true).listen((user) {
      if (user.displayName.isNotEmpty) {
        userSubject.add(user);
      } else {
        userSubject.addError('displayName shouldn\nt be empty');
      }
    }, onError: (e) {
      print('SplashBloc.fetchFirebaseToken - $e');
      userSubject.addError(e);
    });
  }

  String fetchGreeting(String displayName) {
    return '${Constants.welcomeBack}, $displayName!';
  }

  @override
  void dispose() {
    userSubject.close();
  }

}