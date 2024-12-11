import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../features/notification/controller/notification_controller.dart';
import 'notification_setting.dart';

class FirebaseCloudMessagingService extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialization() async {
    await requestPermission();
    await initNotificationInfo();
  }

  //request user for notification permission
  Future<void> requestPermission() async {
    NotificationSettings settings =
        await FirebaseNotificationSetting().notificationSetting();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User Granted Permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("User Granted Provisional Permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log("User Denied Permission");
    }
  }

//get a device token to send notification
  Future<String?> getToken() async {
    String fcmToken = '';
    try {
      await FirebaseMessaging.instance.getToken().then((token) {
        log("FCM Device Token: $token");
        fcmToken = token!;
        return token;
      });
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
    return fcmToken;
  }

  //initialize flutter local notification
  Future<void> initNotificationInfo() async {
    InitializationSettings initializationSettings =
        FirebaseNotificationSetting().initializationSettings();

    //initialization
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      print("tapped on the notification2");
      handleNotificationTappedFormNotificationTray(
          jsonDecode(notificationResponse.payload ?? "{}"));
    });

    listenFirebaseMessages();
  }

  Future setupInteractMessage() async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      await handleNotificationTappedFormNotificationTray(event.data);
    });
  }

  void listenFirebaseMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      int notificationId = math.Random().nextInt(100000);
      log("On Message : ${message.notification?.title}/${message.notification?.body}");
      log("Remote message ${message.data}");
      log("Handling a on message ${message.data}");
      String imageUrl = message.data['image'] ?? '';

      Map<String, dynamic> notificationDetails =
          await FirebaseNotificationSetting()
              .notificationDetails(message, imageUrl);
    });
  }

  Future<void> handleNotificationTappedFormNotificationTray(
      Map<String, dynamic> notificationData) async {

  }

  Future<void> handleNotificationTapped(String? payload) async {

  }

  @override
  void onInit() async {
    //ask for permission
    await requestPermission();
    //listen message from firebase
    await initNotificationInfo();
    super.onInit();
  }
}
