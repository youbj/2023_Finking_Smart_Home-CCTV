import 'package:flutter/material.dart';

class SelectMode extends StatelessWidget {
  const SelectMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모드 설정')),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: Text('카메라 모드')),
          ElevatedButton(onPressed: () {}, child: Text('관리자모드'))
        ],
      )),
    );
  }
}
