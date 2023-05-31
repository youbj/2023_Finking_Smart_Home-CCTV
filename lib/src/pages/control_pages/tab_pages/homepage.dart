import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:guardian/src/dio_server.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final List<String> entries = <String>['a', 'b', 'c', 'd'];
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height * 1,
        child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return Container(
                child: Center(
                  child: Text('순서대로 ${entries[index]}'),
                ),
              );
            }),
      ),
    );
  }
}
