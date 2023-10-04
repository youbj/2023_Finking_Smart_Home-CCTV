import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          child: Form(
              child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: '본명이나 닉네임을 입력하세요'),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
