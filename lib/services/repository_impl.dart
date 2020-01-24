

import 'package:weather_oauth/services/authentication_service.dart';
import 'package:weather_oauth/services/authentication_service_impl.dart';
import 'package:weather_oauth/services/repository.dart';

class RepositoryImpl implements Repository {

  final AuthenticationService _authService = AuthenticationServiceImpl();

  @override
  Stream<String> authenticateUser() {
    return Stream.fromFuture(_authService.fetchGoogleAuthentication())
        .map((authentication) => authentication.user)
        .map((user) => user.displayName);
  }

}