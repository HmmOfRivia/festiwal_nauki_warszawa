import 'package:flutter/material.dart';

final sWhiteBoxShadow = BoxDecoration(
    color: Color(0xFF27005E),
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
          color: Colors.white,
          offset: Offset(2,2),
          blurRadius: 4
      )
    ]
);