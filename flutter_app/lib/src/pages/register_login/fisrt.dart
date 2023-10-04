import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guardian/src/widgets/CustomStyle.dart';
import 'LoginPage.dart';
import 'OnboardingPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class First extends StatelessWidget {
  const First({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: size.height * 0.92,
                  width: size.width * 0.8,
                  padding: EdgeInsets.fromLTRB(0, 100, 50, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${displayName ?? 'Unknown'}님, ',
                            style: CustomStyle.FirstStyle(),
                          ),
                          Text(
                            '환영합니다!',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '회원가입이 완료되었습니다.',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                              Text(
                                '이제 Home Guardian을 통해 집안 안전을 지키세요.',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                              Text(
                                '시작하기 버튼을 누르면 간단한 설명 이후 메인으로 이동합니다. ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.height * 0.08,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OnBoardingPage(),
                        ));
                      },
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
              ]),
            );
          }
        },
      ),
    );
  }
}

/*
StreamBuilder(
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
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: size.height * 0.92,
                  width: size.width * 0.8,
                  padding: EdgeInsets.fromLTRB(0, 100, 50, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${displayName ?? 'Unknown'}님, ',
                            style: CustomStyle.FirstStyle(),
                          ),
                          Text(
                            '환영합니다!',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        width: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '회원가입이 완료되었습니다.',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                              Text(
                                '이제 Home Guardian을 통해 집안 안전을 지키세요.',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              ),
                              Text(
                                '시작하기 버튼을 누르면 간단한 설명 이후 메인으로 이동합니다. ',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: size.height * 0.08,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => OnBoardingPage(),
                        ));
                      },
                      child: Text(
                        '시작하기',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                ),
              ]),
            );
          }
        },
      ),*/