import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festiwal_nauki_warszawa/repositories/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository;
  LoginBloc({LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginWithCredentialsPressed) {
      yield* _mapLoginWithCredentials(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginWithCredentials(
      {String email, String password}) async* {
    yield LoginState.loading();

    try {
      final logged =
          await _loginRepository.signInWithCredentials(email, password);
      if (logged) {
        yield LoginState.success();
      } else {
        yield LoginState.failure();
      }
    } catch (_) {
      yield LoginState.failure();
    }
  }
}
