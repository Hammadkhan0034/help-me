import 'dart:convert';
import 'dart:math' as math;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //function to get device token on which we will send the notifications
  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    print('token $token');
    return token!;
  }

  Future isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print('refresh ' + event.toString());
      }
    });
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher.png');
    var iosInitializationSettings = const DarwinInitializationSettings();
    var initializationSetting = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveBackgroundNotificationResponse: (payload) {});
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("here is the notification payload");
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data);
      }
      showNotification(message);
    });
  }

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

//function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    String title = message.notification!.title ?? '';
    String body = message.notification!.body ?? '';
    String type = message.notification!.body ?? '';
    AndroidNotificationDetails androidNotificationDetails;

    AndroidNotificationChannel channel;
    // = AndroidNotificationChannel(
    //   message.notification!.android == null
    //       ? ""
    //       : message.notification!.android!.channelId.toString(),
    //   message.notification!.android == null
    //       ? ""
    //       : message.notification!.android!.channelId.toString(),
    //   importance: Importance.max,
    //   showBadge: true,
    //   playSound: true,
    //   // sound: const RawResourceAndroidNotificationSound('pop')
    // );

    if (message.data["notificationType"] == "0") {
      channel = AndroidNotificationChannel(
        'helpme_normal', // id
        'Casual Notifications', // title.00
        description:
            'This channel is used for casual notifications.', // description
        importance: Importance.high,
        showBadge: true,
        // sound: RawResourceAndroidNotificationSound(
        //     message.notification?.android?.sound),
        playSound: true,
      );
    } else {
      channel = AndroidNotificationChannel(
        'helpme_alert', // id
        'High Importance Notifications', // title
        description:
            'This channel is used for important notifications.', // description
        sound: RawResourceAndroidNotificationSound(
            message.notification?.android?.sound),
        importance: Importance.max,
        showBadge: true,
        playSound: true,
      );
    }

    androidNotificationDetails = AndroidNotificationDetails(
        channel.id.toString(), channel.name.toString(),
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
        sound: channel.sound);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          math.Random().nextInt(100000),
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: jsonEncode(message.data));
    });
  }
}
