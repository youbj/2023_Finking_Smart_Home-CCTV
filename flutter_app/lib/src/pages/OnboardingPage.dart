import 'package:flutter/material.dart';
import 'package:guardian/src/pages/SelectMode.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: '원격 CCTV 카메라 실행',
          body: 'This is the fist page',
          image: Image.asset(
            'assets/images/selfie.png',
            width: 400,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '침입자 감시 기능',
          body: 'This is the second page'
              'We are making on-boarding screens.'
              'It is very interesting ',
          image: Image.asset(
            'assets/images/onborading1.jpg',
            width: 400,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '위급상황 탐지 기능',
          body: 'This is the third page'
              'We are making on-boarding screens.'
              'It is very interesting',
          image: Image.asset(
            'assets/images/danger.jpg',
            width: 400,
          ),
          decoration: getPageDecoration(),
        ),
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
      dotsDecorator: DotsDecorator(),
      dotsContainerDecorator: BoxDecoration(
        color: Colors.white,
      ),
      curve: Curves.linear,
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      imagePadding: EdgeInsets.only(top: 40),
      pageColor: Colors.white,
    );
  }
}
