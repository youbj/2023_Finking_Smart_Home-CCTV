import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guardian/src/App.dart';
import 'package:flutter/material.dart';
import 'package:guardian/src/intro.dart';
import 'package:logger/logger.dart';
import 'fcm_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final logger = Logger();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 앱 초기화를 위해 필요한 코드
  await Firebase.initializeApp();
  String? _fcmToken = await FirebaseMessaging.instance.getToken();
  logger.e(_fcmToken); // FCM 토큰을 로깅
  configureFcmMessageHandling(); // 별도의 Dart 파일에서 가져온 메시지 처리 코드 호출

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}); // super.key -> Key? key 으로 수정

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
