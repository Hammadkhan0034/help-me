import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'fcm_controller.dart';

class FCMInitialization {
  Future<void> initFCM() async {
    try{
      await FirebaseCloudMessagingService().initialization();
      await FirebaseCloudMessagingService().setupInteractMessage();
      // await FirebaseMessaging.instance.getInitialMessage().then((value) async {
      //   log("FIREBASE MESSAGING INITIALIZED");
      //   await FirebaseMessaging.instance.subscribeToTopic('Sentri');
      //
      // });
    }catch(e){
      log("exception in this $e");    }
  }
}
