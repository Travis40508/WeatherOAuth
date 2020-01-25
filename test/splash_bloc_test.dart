import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_oauth/services/repository.dart';

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

      when(_repository.authenticateUser()).thenAnswer((_) => Stream.value(displayName));

      expectLater(_bloc.displayNameStream, emitsInOrder([
        emits(displayName)
      ]));

      _bloc.fetchFirebaseToken();
    });


    test('on failed to retrieve token', () {
      final error = Error();

      when(_repository.authenticateUser()).thenAnswer((_) => Stream.error(error));

      expectLater(_bloc.displayNameStream, emitsInOrder([
        emitsError(error)
      ]));

      _bloc.fetchFirebaseToken();
    });

  });
}