import 'dart:developer';

import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/utils/shared_prefs.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/auth/controller/auth_controller.dart';

class NotificationControllerWidget extends StatefulWidget {
  const NotificationControllerWidget({super.key});

  @override
  _NotificationControllerWidgetState createState() =>
      _NotificationControllerWidgetState();
}

class _NotificationControllerWidgetState
    extends State<NotificationControllerWidget> {
  bool _isNotificationsEnabled = false;


  Future<void> _toggleNotifications(bool isEnabled) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
String token = "";
    if (isEnabled) {
      NotificationSettings settings = await messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
       token = await FirebaseMessaging.instance.getToken() ?? "";
       print("Token: " + token);
       if(token.isEmpty){
          return;
       }
        print("Notifications enabled.");
       await MySharedPrefs().setBool("isNotificationEnabled", isEnabled);
       await Utils.shouldInitNotification(context);
      }
      else if(settings.authorizationStatus == AuthorizationStatus.denied){
        setState(() {
          _isNotificationsEnabled = false;
          MySharedPrefs().setBool("isNotificationEnabled", isEnabled);

        });
        return;
      }
    } else {
      await FirebaseMessaging.instance.deleteToken();
      setState(() {
        _isNotificationsEnabled = false;
      });
      MySharedPrefs().setBool("isNotificationEnabled", isEnabled);

      print("Notifications disabled.");
return;
    }
    try{
      await UserCrud.updateFcm(Get.find<AuthController>().userModel.value.id
          , token);

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
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AColors.dark,
        borderRadius: BorderRadius.circular(10), // Apply custom border radius
      ),
      child: Row(
        children: [
          Text('Notifications',style: const TextStyle(fontSize: 20, color: Colors.white),),
          Spacer(),
          Switch(value: _isNotificationsEnabled, onChanged: _toggleNotifications,
          activeColor: Colors.white,),
        ],
      ),
    );
  }
}
