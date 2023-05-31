import 'package:flutter/material.dart';
import 'package:guardian/src/pages/SelectMode.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(title: 'Welcome', body: '설명문 1'),
        PageViewModel(title: 'Welcome', body: '설명문 2'),
        PageViewModel(title: 'Welcome', body: '설명문 3')
      ],
      done: Text('done'),
      onDone: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SelectMode(),
        ));
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text('skip'),
    );
  }
}
