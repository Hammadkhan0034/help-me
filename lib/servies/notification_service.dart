import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alarm_app/features/notification/screens/notification_screen.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../features/notification/controller/notification_controller.dart';

class NotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('Permission granted: ${settings.authorizationStatus}');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('Permission granted: ${settings.authorizationStatus}');
      }
    } else {
      if (kDebugMode) {
        print('Permission Denied: ${settings.authorizationStatus}');
      }
      Future.delayed(const Duration(seconds: 1), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
  }

  Future<String?> getDeviceToken() async {
    String? token = '';
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      token = await firebaseMessaging.getToken();
      if (kDebugMode) {
        print("Token is = $token");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('Permission granted: ${settings.authorizationStatus}');
      }
    } else {
      if (kDebugMode) {
        print('Permission Denied: ${settings.authorizationStatus}');
      }
      Future.delayed(const Duration(seconds: 1), () {
        AppSettings.openAppSettings(type: AppSettingsType.notification);
      });
    }
    return token;
  }

  void intiLocationNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitSetting =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosInitSetting = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitSetting,
      iOS: iosInitSetting,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // handleMessage(context, message);
      },
    );
  }

//firebaseInit

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      if (kDebugMode) {
        print('Message data: ${message.data}');
        print('Message notification: ${notification?.title}');
        print('Message notification: ${notification?.body}');
      }
      if(Get.isRegistered<NotificationController>()){
        Get.find<NotificationController>().getNotificationsFromNotification();
      }

      if (Platform.isIOS) {
        iosForegroundMessage();
        // handleMessage(context, message);
      }else
      if (Platform.isAndroid) {
        intiLocationNotification(context, message);
        showNotification(message);
        // handleMessage(context, message);
      }
    });
  }

  //show Notification

  Future<void> showNotification(RemoteMessage message) async {
    //channel setting
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        sound: RawResourceAndroidNotificationSound('raw_alarm'),
        enableVibration: true,
        playSound: true);
//android setting
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "",
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            sound: RawResourceAndroidNotificationSound("raw_alarm"));

    //ios setting

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(

          sound: "raw_alarm.aiff",
            presentAlert: true, presentBadge: true, presentSound: true);

    //Combining both setting

    NotificationDetails notificationDetails = NotificationDetails(
        iOS: darwinNotificationDetails, android: androidNotificationDetails);

    //show Notification

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: jsonEncode(message.data));
    });
  }

  // living_plus-channel
  //state handles  background and terminated

  Future<void> setupInteractMessage(BuildContext context) async {
    //background state

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        // handleMessage(context, event);
      },
    );

    //terminated state

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data.isNotEmpty) {
       // handleMessage(context, message);
      }
    });
  }

  //handle message
  // Future<void> handleMessage(
  //     BuildContext context, RemoteMessage message) async {
  //   Get.to(()=> NotificationScreen());
  // }

//ios message
  Future iosForegroundMessage() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
