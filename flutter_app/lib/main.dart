import 'package:guardian/src/App.dart';
import 'package:flutter/material.dart';
import 'package:guardian/src/pages/fisrt.dart';
import 'package:guardian/src/pages/intro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'guardian',
        home: FutureBuilder(
            future: Future.delayed(
                const Duration(seconds: 3), () => "Intro Completed."),
            builder: (context, snapshot) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: _splashLoadingWidget(snapshot),
              );
            }));
  }
}

Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
  if (snapshot.hasError) {
    return const Text("Error!!");
  } else if (snapshot.hasData) {
    return const App();
  } else {
    return const Intro();
  }
}
