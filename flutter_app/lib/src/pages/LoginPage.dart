import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../CustomStyle.dart';

class LoginWidget extends StatelessWidget {
  const LoginWidget({super.key});

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                //color: Colors.amber[700],
                height: size.height * 0.7,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                  width: size.width * 0.7,
                  height: size.height * 0.7,
                  child: Image.asset('assets/images/Logo.png'),
                ),
              ),
              SizedBox(
                //color: Colors.red,
                width: size.width * 0.6,
                height: size.height * 0.3,
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.45,
                      //color: Colors.blueGrey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                '이용약관 및 개인정보 취급방침',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (constraints.maxWidth < 600) {
                                      return Text(
                                        '회원에 가입하시면 위 약관, 개인 정보 취급방침 및 14세 이상 서비스 이용에 대해 이해하고 동의한 것으로 간주합니다.',
                                        style: CustomStyle.LoginStyle(),
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (Text(
                                            '회원에 가입하시면 위 약관, 개인 정보 취급방침 및 14세 이상 서비스 이용에 대해 이해하고 ',
                                            style: CustomStyle.LoginStyle(),
                                          )),
                                          (Text(
                                            '동의한 것으로 간주합니다.',
                                            style: CustomStyle.LoginStyle(),
                                          )),
                                        ],
                                      );
                                    }
                                  }),
                                ])
                          ]),
                    ),
                    Container(
                      width: size.width * 0.45,
                      height: 45,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                            padding: EdgeInsets.zero),
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100)),
                              child: Image.asset('assets/images/google.png'),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  'Sign In with Google',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Navigator.of(context).pushReplacement(MaterialPageRoute(
//               builder: (context) => OnBoardingPage(),
//              ));
