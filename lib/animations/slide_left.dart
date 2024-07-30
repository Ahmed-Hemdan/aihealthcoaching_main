import 'package:flutter/material.dart';

class SlideLeft extends PageRouteBuilder
{
  final page;
  SlideLeft({this.page}) : super(pageBuilder: (context, animation, animationTwo) => page, transitionsBuilder: (context, animation, animationTwo, child){
    var begin = 0.0;
    var end = 1.0;
    var tween = Tween(begin: begin, end: end);
    //var offsetAnimation = animation.drive(tween);
    var curvesAnimation = CurvedAnimation(parent: animation, curve: Curves.linearToEaseOut);
    //return SlideTransition(position: tween.animate(curvesAnimation), child: child,);
    return ScaleTransition(scale: tween.animate(curvesAnimation), child: child,);
  } );
}