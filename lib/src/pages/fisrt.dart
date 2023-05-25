import 'package:guardian/src/pages/SelectMode.dart';
import 'package:guardian/src/App.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'LoginPage.dart';
import 'OnboardingPage.dart';

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 로딩 상태 처리
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // 오류 상태 처리
            return Text('오류 발생: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return LoginWidget();
          } else {
            final displayName = snapshot.data?.displayName;
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${displayName ?? 'Unknown'}님 환영합니다.'),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => OnBoardingPage(),
                          ));
                        },
                        child: Text('시작하기'))
                  ]),
            );
          }
        },
      ),
    );
  }
}
