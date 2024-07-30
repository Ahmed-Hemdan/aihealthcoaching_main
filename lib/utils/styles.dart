import 'package:flutter/material.dart';

class Styles {
  static TextStyle defaultStyle = TextStyle(
    color: Colors.grey[700],
  );
  static TextStyle h1 = defaultStyle.copyWith(
      fontSize: 15.0, height: 20 / 15, fontWeight: FontWeight.bold);

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 15.0,
  );

  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[700],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
        width: 3.0,
      ),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey[700] ?? Colors.grey,
        width: 3.0,
      ),
      gapPadding: 2.0,
    ),
    hintStyle: TextStyle(
      color: Colors.grey[700],
    ),
  );

  static TextStyle error = defaultStyle.copyWith(
    color: Colors.red,
    fontWeight: FontWeight.bold,
    fontSize: 12.0,
  );
}
