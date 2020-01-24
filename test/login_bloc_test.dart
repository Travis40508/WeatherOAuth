import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_oauth/blocs/login_bloc.dart';
import 'package:weather_oauth/services/repository.dart';

import 'mocks/mock_repository.dart';

void main() {
  Repository _repository;
  LoginBloc _bloc;

  setUp(() {
    _repository = MockRepository();
    _bloc = LoginBloc(_repository);
  });

  group('testing authentication', () {

    test('authentication happy path', () {
      final displayName = "foo";
      when(_repository.authenticateUser()).thenAnswer((_) => Stream.value(displayName));

      expectLater(_bloc.authResultStream, emitsInOrder([
        emits(displayName)
      ]));

      _bloc.authenticateUser();
    });

    test('authentication error scenario', () {
      final error = Error();
      when(_repository.authenticateUser()).thenAnswer((_) => Stream.error(error));

      expectLater(_bloc.authResultStream, emitsInOrder([
        emitsError(error)
      ]));

      _bloc.authenticateUser();
    });

  });

}