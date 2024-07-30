import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    Key? key,
    @required this.title,
    @required this.fontSize,
  }) : super(key: key);

  final String? title;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? "",
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor),
    );
  }
}
