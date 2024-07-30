import 'package:aihealthcoaching_main/common/constants.dart';
import 'package:flutter/material.dart';

class OffLineScreen extends StatefulWidget {
  const OffLineScreen({Key? key}) : super(key: key);

  @override
  _OffLineScreenState createState() => _OffLineScreenState();
}

class _OffLineScreenState extends State<OffLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppName),
      ),
    );
  }
}
