import 'package:festiwal_nauki_warszawa/blocs/bloc_observer.dart';
import 'package:festiwal_nauki_warszawa/login_page/login_screen.dart';
import 'package:festiwal_nauki_warszawa/repositories/events_detail_page_repository.dart';
import 'package:festiwal_nauki_warszawa/repositories/login_repository.dart';
import 'package:festiwal_nauki_warszawa/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/authentication/authentication_bloc.dart';
import 'home_page/events_slider_page.dart';

void main() {
  Bloc.observer = BlocObserverExtended();
  final LoginRepository loginRepository = LoginRepository();
  runApp(BlocProvider(
      create: (context) => AuthenticationBloc(loginRepository: loginRepository)
        ..add(AuthenticationStarted()),
      child: MyApp(loginRepository: loginRepository)));
}

class MyApp extends StatelessWidget {
  final LoginRepository _loginRepository;
  MyApp({LoginRepository loginRepository}) : _loginRepository = loginRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
      if (state is AuthenticationSuccess) {
        return EventsSlider(user: state.user);
      }
      if (state is AuthenticationFailure) {
        return LoginScreen(
          loginRepository: _loginRepository,
        );
      }
      return Scaffold(
          body: Stack(
        children: [
          buildBackground(),
          Center(
            child: Text(
              "Loading",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ));
    }));
  }
}
