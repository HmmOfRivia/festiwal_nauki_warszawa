import 'package:flutter/material.dart';

import 'register_styles.dart';

class RegisterTemplate extends StatefulWidget {

  @override
  _RegisterTemplateState createState() => _RegisterTemplateState();
}

class _RegisterTemplateState extends State<RegisterTemplate> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              _buildRegisterButton(context),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo(){
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
        children: <Widget>[
          Image.asset('images/festiwal_nauki_logo.png')
        ],
      ),
    );
  }

  Widget _buildText(){
    return Text(
      'Zarejestruj się',
      style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold),
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
          child: TextFormField(
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
          child: TextFormField(
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

  Widget _buildRegisterButton(context){
    return Container(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        onPressed: () => print("XD"),
        splashColor: Color(0xFF5c0075),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: Text(
          'Zarejestruj',
          style: TextStyle(color: Color(0xFF5c0075)),
        ),
      ),
    );
  }
}
