import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: Center(
          child: Text(
        'Intro Screen',
        style: TextStyle(fontSize: 30, color: Colors.white),
      )),
    );
  }
}
