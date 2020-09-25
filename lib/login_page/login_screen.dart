import 'package:festiwal_nauki_warszawa/blocs/login/login_bloc.dart';
import 'package:festiwal_nauki_warszawa/login_page/login_template.dart';
import 'package:festiwal_nauki_warszawa/repositories/login_repository.dart';
import 'package:festiwal_nauki_warszawa/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final LoginRepository _loginRepository;
  const LoginScreen({LoginRepository loginRepository}): _loginRepository = loginRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(loginRepository: _loginRepository),
        child: Stack(
          children: [
            buildBackground(),
            SingleChildScrollView(
              child: Container(
                child: LoginTemplate(loginRepository: _loginRepository),
              ),
            )
          ],
        ),
      )
    );
  }
}