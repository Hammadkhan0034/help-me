

import 'dart:ui';

import 'package:alarm_app/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialController extends GetxController{
  GlobalKey alarmKey = GlobalKey();
  GlobalKey doorKey = GlobalKey();
  GlobalKey settingsKey = GlobalKey();
  GlobalKey locationKey = GlobalKey();
  GlobalKey notificationKey = GlobalKey();
  TutorialCoachMark? tutorialCoachMark;
  final String isHomeTutorialFinishedOnce = "isHomeTutorialFinishedOnce", isSettingsTutorialFinishedOnce = "isSettingsTutorialFinishedOnce";

  GlobalKey subscribeKey = GlobalKey();
  GlobalKey contactsKey = GlobalKey();
  GlobalKey groupsKey = GlobalKey();
  GlobalKey primaryGroupKey = GlobalKey();
  GlobalKey primaryOutdoorKey = GlobalKey();
  GlobalKey notificationStatusKey = GlobalKey();
  GlobalKey deleteAccountKey = GlobalKey();
  List<TargetFocus> targets =[];
  ScrollController scrollController = ScrollController();

  restartTutorial(BuildContext context){
    MySharedPrefs().setBool(isSettingsTutorialFinishedOnce, false);
    MySharedPrefs().setBool(isHomeTutorialFinishedOnce, false);
    showHomeTutorial(context);

  }
  List<TargetFocus> _createHomeTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(

        identify: "alarmKey",
        keyTarget: alarmKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "ALARM",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Alarm button will provide you a sound for your surroundings in case of emergency.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      controller.next();
                    },
                    child: const Icon(Icons.chevron_right,size: 28,),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "doorKey",
        keyTarget: doorKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "DOOR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      """Indoor - To send an alarm message to the people when you are in your neighborhood area.\n\nOutdoor - Sending alarm message to the group needed when you are outside, including location.""",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
Spacer(),                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "settingsKey",
        keyTarget: settingsKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "SETTINGS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can subscribe to subscription, and add contacts and create group, enable or disable notification and set primary indoor and outdoor.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
                      Spacer(),                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "locationKey",
        keyTarget: locationKey,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Location Trail",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Show your location to a specific people you give permission to and access their location with permission as well.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
                      Spacer(),                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "notificationsKey",
        keyTarget: notificationKey,
        shape: ShapeLightFocus.RRect,

        color: Colors.purple,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Notification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can receive indoor,outdoor notification and contact requests here.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ElevatedButton(
                      onPressed: () {
                        controller.previous();
                      },
                      child: const Icon(Icons.chevron_left),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        MySharedPrefs().setBool(isHomeTutorialFinishedOnce, true);
                        controller.next();
                      },
                      child: Text("Finish",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),

                  ],)

                ],
              );
            },
          )
        ],
        radius: 5,
      ),
    );


    return targets;
  }
  List<TargetFocus> _createSettingTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "subscribe",
        keyTarget: subscribeKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Subscription",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "you have free 7 days trial. After 7 days tou will have to buy subscription to access all the features again only for RM12.99 for a year.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      controller.next();
                    },
                    child: const Icon(Icons.chevron_right,size: 28,),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "contacts",
        keyTarget: contactsKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Contacts",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can add contacts and the added contacts will appear here, click the plus sign to add contact to the app.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
Spacer(),                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );

    targets.add(
      TargetFocus(
        identify: "groups",
        keyTarget: groupsKey,
        alignSkip: Alignment.topRight,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Group",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can create groups and view the created groups here, click the plus sign on the right side of app bar to create a new group.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
                      Spacer(),                      ElevatedButton(
                        onPressed: () {
                          scrollController.animateTo( scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeOut,);
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "primaryIndoorGroup",
        keyTarget: primaryGroupKey,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Primary Indoor Group",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can set a default primary indoor group here. It will show on door page on default.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
                      Spacer(),                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );targets.add(
      TargetFocus(
        identify: "primaryOutdoorGroup",
        keyTarget: primaryOutdoorKey,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Primary Outdoor Group",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "You can set a default primary outdoor group here. It will show on door page on default.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
                      Spacer(),                      ElevatedButton(
                        onPressed: () {

                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );targets.add(
      TargetFocus(
        identify: "notificationStatus",
        keyTarget: notificationStatusKey,
        shape: ShapeLightFocus.RRect,

        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Notification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Always enable notification first to receive alarm sound",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left,size: 28,),
                      ),
                      Spacer(),                      ElevatedButton(
                        onPressed: () {
                          controller.next();
                        },
                        child: const Icon(Icons.chevron_right,size: 28,),
                      ),
                    ],
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "delete",
        keyTarget: deleteAccountKey,
        shape: ShapeLightFocus.RRect,

        color: Colors.purple,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Delete Account",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Warning!. All of your data will be permanently deleted if you delete your account and you will not be able to recover it.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          controller.previous();
                        },
                        child: const Icon(Icons.chevron_left),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          MySharedPrefs().setBool(isSettingsTutorialFinishedOnce, true);

                          controller.next();
                        },
                        child: Text("Finish",style: TextStyle(fontWeight: FontWeight.bold),),
                      ),

                    ],)
                ],
              );
            },
          )
        ],
        radius: 5,
      ),
    );


    return targets;
  }


  void showHomeTutorial(BuildContext context) {
    if(MySharedPrefs().getBool(isHomeTutorialFinishedOnce)) return;
    createHomeTutorial();
    tutorialCoachMark?.show(context: context);
  }
  void createHomeTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createHomeTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      showSkipInLastTarget: false,
      paddingFocus: 10,
      opacityShadow: 0.5,
        alignSkip: Alignment.topRight,

      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        MySharedPrefs().setBool(isHomeTutorialFinishedOnce, true);

        print("finish");
      },
      onClickTarget: (target) {
        tutorialCoachMark?.next();
        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        tutorialCoachMark?.next();

        print('onClickOverlay: $target');
      },
      onSkip: () {
        MySharedPrefs().setBool(isHomeTutorialFinishedOnce, true);

        print("skip");
        return true;
      },
    );
  }

  void showSettingTutorial(BuildContext context) {
    if(MySharedPrefs().getBool(isSettingsTutorialFinishedOnce)) return;

    createSettingTutorial();
    tutorialCoachMark?.show(context: context);
  }
  void createSettingTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createSettingTargets(),
      colorShadow: Colors.red,
      showSkipInLastTarget: false,
      textSkip: "SKIP",
      alignSkip: Alignment.topRight,
      paddingFocus: 10,
      opacityShadow: 0.5,
      imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      onFinish: () {
        MySharedPrefs().setBool(isSettingsTutorialFinishedOnce, true);

        print("finish");
      },
      onClickTarget: (target) {
        tutorialCoachMark?.next();

        print('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        tutorialCoachMark?.next();

        print('onClickOverlay: $target');
      },
      onSkip: () {
        MySharedPrefs().setBool(isSettingsTutorialFinishedOnce, true);

        print("skip");
        return true;
      },
    );
    
  }
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

}