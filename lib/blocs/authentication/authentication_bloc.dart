import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:festiwal_nauki_warszawa/repositories/login_repository.dart';
import 'package:festiwal_nauki_warszawa/utils/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginRepository _loginRepository;

  AuthenticationBloc({LoginRepository loginRepository})
      : _loginRepository = loginRepository,
        super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStarted();
    }
    if (event is AuthenticationLoggedIn) {
      yield* _mapAuthenticationLoggedIn();
    }
    if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOut();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOut() async* {
    yield AuthenticationFailure();
    _loginRepository.userSignOut(await getUserFromSharedPreferences());
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedIn() async* {
    yield AuthenticationSuccess(await getUserFromSharedPreferences());
  }

  Stream<AuthenticationState> _mapAuthenticationStarted() async* {

    User user = await getUserFromSharedPreferences();
    final isSignedIn = await _loginRepository.isSignedIn(user);
    if (isSignedIn) {

      yield AuthenticationSuccess(user);
    } else {
      yield AuthenticationFailure();
    }
  }

  Future<User> getUserFromSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userSession = sharedPreferences.getString('userSession');
    String token = sharedPreferences.getString('token');
    return User(userSession, token);
  }
}
