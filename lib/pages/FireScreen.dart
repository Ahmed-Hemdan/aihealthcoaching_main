import 'package:flutter/material.dart';

class FireScreen extends StatefulWidget {
  const FireScreen({Key? key}) : super(key: key);

  @override
  _FireScreenState createState() => _FireScreenState();
}

class _FireScreenState extends State<FireScreen> {
  @override
  void initState() {
    super.initState();

    new Future.delayed(const Duration(seconds: 8), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Congratulation"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            child: Image.asset(
              "assets/images/icons/fireworks.gif",
              width: 500,
              height: 500,
            ),
          ),
        ),
      ),
    );
  }
}
