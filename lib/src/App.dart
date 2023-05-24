import 'package:guardian/src/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Firebase load fail'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Home();
          }
          return CircularProgressIndicator();
        });
  }
}
