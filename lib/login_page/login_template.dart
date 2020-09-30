import 'package:festiwal_nauki_warszawa/blocs/authentication/authentication_bloc.dart';
import 'package:festiwal_nauki_warszawa/blocs/login/login_bloc.dart';
import 'package:festiwal_nauki_warszawa/register_page/register_screen.dart';
import 'package:festiwal_nauki_warszawa/repositories/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:festiwal_nauki_warszawa/utils/Strings.dart' as Strings;

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
                    Text(Strings.LOG_IN_MESSAGE),
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
                    Text(Strings.LOGIN_ERROR),
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
      padding: EdgeInsets.only(top: 40.0),
      width: double.infinity,
      height: 160,
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
      Strings.LOG_IN,
      style: TextStyle(
          color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Strings.EMAIL,
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
                hintText: Strings.EMAIL_HINT,
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
          Strings.PASSWORD,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft, 
          decoration: BoxDecoration(
            color: Color(0x66D2006B),
            borderRadius: BorderRadius.circular(20)
          ),
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
                hintText: Strings.PASSWORD_HINT,
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
          Strings.LOG_IN,
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
      child: Text(Strings.NEW_ACCOUNT,
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

