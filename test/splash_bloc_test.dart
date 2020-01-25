import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_oauth/blocs/splash_bloc.dart';
import 'package:weather_oauth/services/repository.dart';
import 'package:weather_oauth/utils/constants.dart';

import 'mocks/mock_repository.dart';

void main() {
  SplashBloc _bloc;
  Repository _repository;

  setUp(() {
    _repository = MockRepository();
    _bloc = SplashBloc(_repository);
  });

  group('fetching firebase token', () {

    test('emitting displayName on token received', () {
      final displayName = 'foo';

      when(_repository.authenticateUser(true)).thenAnswer((_) => Stream.value(displayName));

      expectLater(_bloc.displayNameStream, emitsInOrder([
        emits(displayName)
      ]));

      _bloc.fetchFirebaseToken();
    });


    test('on failed to retrieve token', () {
      final error = Error();

      when(_repository.authenticateUser(true)).thenAnswer((_) => Stream.error(error));

      expectLater(_bloc.displayNameStream, emitsInOrder([
        emitsError(error)
      ]));

      _bloc.fetchFirebaseToken();
    });

    test('error when displayName is empty', () {
      final displayName = Constants.empty;

      when(_repository.authenticateUser(true)).thenAnswer((_) => Stream.value(displayName));

      expectLater(_bloc.displayNameStream, emitsInOrder([
        emitsError(anything)
      ]));

      _bloc.fetchFirebaseToken();
    });

  });

  test('welcome back formatting is proper', () {
    final displayName = 'foo';

    expect(_bloc.fetchGreeting(displayName), 'Welcome Back, foo!');
  });
}