import 'dart:developer';

import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/utils/shared_prefs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/controller/auth_controller.dart';

class NotificationControllerWidget extends StatefulWidget {
  const NotificationControllerWidget({super.key});

  @override
  _NotificationControllerWidgetState createState() =>
      _NotificationControllerWidgetState();
}

class _NotificationControllerWidgetState
    extends State<NotificationControllerWidget> {
  bool _isNotificationsEnabled = true;


  Future<void> _toggleNotifications(bool isEnabled) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
String token = "";
    if (isEnabled) {
      NotificationSettings settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
       token = await FirebaseMessaging.instance.getToken() ?? "";
       if(token.isEmpty){
          return;
       }
        print("Notifications enabled.");
      }else if(settings.authorizationStatus == AuthorizationStatus.denied){
        setState(() {
          _isNotificationsEnabled = false;
        });
        return;
      }
    } else {
      await FirebaseMessaging.instance.deleteToken();
      setState(() {
        _isNotificationsEnabled = false;
      });
      print("Notifications disabled.");
    }
    try{
      await UserCrud.updateFcm(Get.find<AuthController>().userModel.value.id
          , token);

      MySharedPrefs().setBool("isNotificationEnabled", isEnabled);
      setState(() {
        _isNotificationsEnabled = isEnabled;
      });
    }catch(e,st){
      log("ToggleNotification",error:e,stackTrace:st);
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    _isNotificationsEnabled =       MySharedPrefs().getBool("isNotificationEnabled");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(value: _isNotificationsEnabled, onChanged: _toggleNotifications,
    activeColor: Colors.red,);
  }
}
