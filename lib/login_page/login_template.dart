import 'package:festiwal_nauki_warszawa/blocs/authentication/authentication_bloc.dart';
import 'package:festiwal_nauki_warszawa/blocs/login/login_bloc.dart';
import 'package:festiwal_nauki_warszawa/register_page/register_screen.dart';
import 'package:festiwal_nauki_warszawa/register_page/register_template.dart';
import 'package:festiwal_nauki_warszawa/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_styles.dart';

class LoginTemplate extends StatefulWidget {
  final LoginRepository _loginRepository;
  LoginTemplate({LoginRepository loginRepository})
      : _loginRepository = loginRepository;

  @override
  _LoginTemplateState createState() => _LoginTemplateState();
}

class _LoginTemplateState extends State<LoginTemplate> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logowanie...'),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  ],
                ),
                backgroundColor: Colors.grey,
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(
            AuthenticationLoggedIn(),
          );
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Logowanie się nie powiodło'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.grey,
              ),
            );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
        return Column(
          children: [
            _buildLogo(),
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  _buildText(),
                  _buildEmail(),
                  SizedBox(height: 20),
                  _buildPassword(),
                  SizedBox(height: 20),
                  _buildLoginButton(context),
                  SizedBox(height: 20),
                  _buildRegisterButton(context)
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50))),
      child: Column(
        children: <Widget>[Image.asset('images/festiwal_nauki_logo.png')],
      ),
    );
  }

  Widget _buildText() {
    return Text(
      'Zaloguj się',
      style: TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: "Wpisz swój email",
                hintStyle: kHintTextStyle),
          ),
        )
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hasło",
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: "Wpisz swoje hasło",
                hintStyle: kHintTextStyle),
          ),
        )
      ],
    );
  }

  Widget _buildLoginButton(context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        onPressed: () {
          _buttonClicked();
        },
        splashColor: Color(0xFF5c0075),
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Text(
          'Zaloguj',
          style: TextStyle(color: Color(0xFF5c0075)),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return RegisterScreen();
        }));
      },
      child: Text('Nie masz konta? Zarejestruj się!',
          style: TextStyle(color: Colors.white)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _buttonClicked() {
    _loginBloc.add(LoginWithCredentialsPressed(_emailController.text, _passwordController.text));
  }


}

