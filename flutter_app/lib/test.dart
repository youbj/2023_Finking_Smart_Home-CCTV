import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Test());
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.e('Received a message in the foreground:');
      if (message.notification != null) {
        logger.e('Title: ${message.notification!.title}');
        logger.e('Body: ${message.notification!.body}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.e('User tapped the notification:');
      if (message.notification != null) {
        logger.e('Title: ${message.notification!.title}');
        logger.e('Body: ${message.notification!.body}');
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        logger.e('User opened the app via a notification:');
        if (message.notification != null) {
          logger.e('Title: ${message.notification!.title}');
          logger.e('Body: ${message.notification!.body}');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('FCM Example'),
        ),
        body: Center(
          child: Text('FCM Example'),
        ),
      ),
    );
  }
}
