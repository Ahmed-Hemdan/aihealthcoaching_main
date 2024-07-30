import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  const CustomInkWell(
      {Key? key,
      @required this.title,
      @required this.fontSize,
      @required this.route,
        this.color,
      @required this.fontWeight})
      : super(key: key);

  final String? title;
  final double? fontSize;
  final String? route;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "$route");
      },
      child: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text(
          title ?? "",
          style: TextStyle(
              color: color, fontWeight: fontWeight, fontSize: fontSize),
        ),
      ),
    );
  }
}
