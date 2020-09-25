import 'package:festiwal_nauki_warszawa/login_page/login_template.dart';
import 'package:festiwal_nauki_warszawa/register_page/register_template.dart';
import 'package:festiwal_nauki_warszawa/widgets/background.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            buildBackground(),
            SingleChildScrollView(
              child: Container(
                child: RegisterTemplate(),
            ),
            )
          ],
        )
    );
  }
}