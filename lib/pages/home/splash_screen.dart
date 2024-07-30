import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import '../../common/constants.dart';
import '../../init.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool seen = false;

  Future<bool> isSeen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('seen') ?? false;
  }

  @override
  void initState() {
    super.initState();
    isSeen().then((value) {
      setState(() {
        seen = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000, // Duration in milliseconds
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (kTextLogoInSplashScreen == true)
            Text(
              kAppName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          Image.asset(
            kLogoImageLocal,
            height: 300,
            width: 300,
          ),
        ],
      ),
      nextScreen: RouterScreen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.white,
    );
  }
}