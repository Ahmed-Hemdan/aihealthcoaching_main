import 'package:flutter/material.dart';

class CustomTitleBold extends StatelessWidget {
  const CustomTitleBold(
      {Key? key, @required this.title, @required this.fontSize, this.color})
      : super(key: key);

  final String? title;
  final double? fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
