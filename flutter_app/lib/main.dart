import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:guardian/src/App.dart';
import 'package:flutter/material.dart';
import 'package:guardian/src/intro.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'fcm_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class MessageData with ChangeNotifier {
  Map<String, dynamic>? _data;

  Map<String, dynamic>? get data => _data;

  void updateData(Map<String, dynamic> newData) {
    _data = newData;
    notifyListeners();
  }
}

final logger = Logger();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  String? _fcmToken = await FirebaseMessaging.instance.getToken();
  logger.i('FCM Token: $_fcmToken');
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  configureFcmMessageHandling();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageData()),
        // 다른 프로바이더 추가 가능
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String messageTitle = "";
  String messageBody = "";

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('Received a message in the foreground:');
      print('Message data: ${message.data}');
      
      if (message.notification != null) {
        setState(() {
          messageTitle = message.notification!.title ?? "";
          messageBody = message.notification!.body ?? "";
        });
        context.read<MessageData>().updateData(message.data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logger.i('User tapped the notification:');
      if (message.notification != null) {
        setState(() {
          messageTitle = message.notification!.title ?? "";
          messageBody = message.notification!.body ?? "";
        });
        context.read<MessageData>().updateData(message.data);
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        logger.i('User opened the app via a notification:');
        if (message.notification != null) {
          setState(() {
            messageTitle = message.notification!.title ?? "";
            messageBody = message.notification!.body ?? "";
          });
          context.read<MessageData>().updateData(message.data);
        }
      }
    });
  }

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

  Widget _splashLoadingWidget(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return const Text("Error!!");
    } else if (snapshot.hasData) {
      return const App();
    } else {
      return const Intro();
    }
  }


}