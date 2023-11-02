import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

void configureFcmMessageHandling() {
  final logger = Logger();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //foground
    if (message.notification != null) {
      logger.e(message.notification!.title);
      logger.e(message.notification!.body);
      logger.e(message.data["click_action"]);
      final notification = message.notification!;
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    //백그라운드
    if (message != null) {
      if (message.notification != null) {
        logger.e(message.notification!.title);
        logger.e(message.notification!.body);
        logger.e(message.data["click_action"]);
      }
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //
    if (message != null) {
      if (message.notification != null) {
        logger.e(message.notification!.title);
        logger.e(message.notification!.body);
        logger.e(message.data["click_action"]);
      }
    }
  });
}
