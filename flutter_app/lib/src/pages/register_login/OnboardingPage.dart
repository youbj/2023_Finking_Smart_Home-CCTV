import 'package:flutter/material.dart';
import 'package:guardian/src/pages/control_pages/SelectMode.dart';
import 'package:guardian/src/widgets/CustomStyle.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return IntroductionScreen(
      bodyPadding: EdgeInsets.fromLTRB(0, 100, 0, 0),
      pages: [
        PageViewModel(
          title: '원격 CCTV 카메라',
          bodyWidget: Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Column(
              children: [
                Text(
                  '우리의 안전을 보호하는 유용한 기술',
                  style: CustomStyle.OnboardingStyle(),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '언제, 어디서나 소중한 공간을',
                  style: CustomStyle.OnboardingStyle(),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '실시간으로 모니터링하고, 감지하고',
                  style: CustomStyle.OnboardingStyle(),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '지킬 수 있습니다!',
                  style: CustomStyle.OnboardingStyle(),
                ),
              ],
            ),
          ),
          image: Image.asset(
            'assets/images/selfie.png',
            width: 800,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '침입자 감시 기능',
          bodyWidget: Column(
            children: [
              Text(
                '이 기능은 강력한 보안 솔루션을 제공합니다. ',
                style: CustomStyle.OnboardingStyle(),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '카메라가 움직임을 감지하고 즉시 파악하여',
                style: CustomStyle.OnboardingStyle(),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '사건 발생 시 적절한 조치를 취할 수 있도록 도와줍니다.',
                style: CustomStyle.OnboardingStyle(),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '카메라는 움직임을 감지하여 침입자를 판단합니다.',
                style: CustomStyle.OnboardingStyle(),
              ),
            ],
          ),
          image: Image.asset(
            'assets/images/onborading1.jpg',
            width: 500,
          ),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: '위급상황 탐지 기능',
          bodyWidget: Column(
            children: [
              Text(
                '이 기능은 위험 상황을 감지하고 즉시 알림을 보내고',
                style: CustomStyle.OnboardingStyle(),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '신속한 대응을 제공합니다. 위급상황 탐지 기능은 ',
                style: CustomStyle.OnboardingStyle(),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '비정상적인 패턴을 식별하는 AI 기술을 사용합니다.',
                style: CustomStyle.OnboardingStyle(),
              ),
            ],
          ),
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
