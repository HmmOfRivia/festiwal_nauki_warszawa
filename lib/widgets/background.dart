import 'package:flutter/material.dart';

Widget buildBackground() {
  return Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF21005e), Color(0xFFD2006B)],
            )),
  );
}
