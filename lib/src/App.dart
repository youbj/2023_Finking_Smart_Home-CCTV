import 'package:guardian/firebase_options.dart';
import 'package:guardian/src/pages/fisrt.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Firebase load fail'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return First();
          }
          return CircularProgressIndicator();
        });
  }
}

//flutter run -d chrome --web-hostname localhost --web-port 5000