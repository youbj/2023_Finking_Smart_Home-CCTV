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
          body: '우리의 안전을 보호하는 데 매우 유용한 도구입니다. '
              '이제 여러분은 언제 어디서나 집, 사무실, 상점 등을 '
              '실시간으로 모니터링하고, 사건 발생 시 신속히 대응할 수 있습니다.',
          image: Image.asset(
            'assets/images/selfie.png',
            width: 400,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '침입자 감시 기능',
          body: '침입자 감시 기능은 강력한 보안 솔루션을 제공합니다. '
              '이 기능은 카메라가 움직임을 감지하고 '
              '이를 즉시 파악하여 사건 발생 시 적절한 조치를 취할 수 있도록 도와줍니다.'
              '카메라는 지정된 영역에서 움직임을 감지하면 이를 분석하여 실제로 침입자인지를 판단합니다.',
          image: Image.asset(
            'assets/images/onborading1.jpg',
            width: 400,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '위급상황 탐지 기능',
          body: '이 기능은 사전에 정의된 위험 상황을 감지하고 즉시 알림을 보내어 '
              '신속한 대응을 가능케 합니다. 또한, 위급상황 탐지 기능은 AI 기술을'
              '사용하여 의심스러운 행동이나 비정상적인 패턴을 식별할 수도 있습니다. ',
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
