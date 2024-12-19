import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/core/subscription_controller.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/door/screens/door_screen.dart';
import 'package:alarm_app/features/notification/screens/notification_screen.dart';
import 'package:alarm_app/features/plans/screens/plans_screen.dart';
import 'package:alarm_app/features/settings/screens/settings_screen.dart';
import 'package:alarm_app/features/trail_location/controller/LocationManageController.dart';
import 'package:alarm_app/features/trail_location/screen/location_manage_screen.dart';
import 'package:alarm_app/utils/connection_listener.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/notification_controller_widget.dart';
import 'package:alarm_app/widgets/notification_icon_with_count.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contact/add_contacts_controller/add_contact_controller.dart';
import '../../group/controller/group_controller.dart';
import '../controller/alar_controller.dart';

class HelpMeScreen extends StatelessWidget {
  final AlarmController alarmController = Get.put(AlarmController(),permanent: true);

  final ContactController addContactController =
  Get.put(ContactController(), permanent: true);
  final LocationManageController locationManageController =
  Get.put(LocationManageController(), permanent: true);

  final GroupController createGroupController =
  Get.put(GroupController(),permanent: true);
  final InAppPurchaseUtils inAppPurchaseUtils = Get.find<InAppPurchaseUtils>();

  HelpMeScreen({super.key});
void goToSubscription(){
  Get.to(()=> PaymentScreen());
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NotificationIconWithCount(
          onPress: () {
            ConnectionStatusListener.isOnHomePage = false;
            Get.to(() => NotificationScreen());
          },
        ),
        title: const Text(
          "HELP ME",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,

      ),
      body: Stack(
        children: [
          GradientContainer(
            mTop: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    "ALARM",
                    style: TextStyle(
                        color: AColors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 25),
                  AElevatedButton(
                      title: "ALARM",
                      onPress: () {
                        alarmController.playAlarm();
                        alarmController.showAlert(context);

                        // Get.to(const NotificationScreen());
                      }),
                  const SizedBox(height: 15),
                  Obx(() {
                    return AElevatedButton(
                        bgColor: inAppPurchaseUtils.isSubscriptionActive.value
                            ? AColors.dark
                            : Colors.grey,
                        title: "DOOR",
                        onPress: inAppPurchaseUtils.isSubscriptionActive.value
                            ? () {
                          ConnectionStatusListener.isOnHomePage = false;
                          Get.to(() => DoorScreen());
                        }
                            : goToSubscription);
                  }),
                  const SizedBox(height: 15),
                  AElevatedButton(

                        title: "SETTINGS",
                        onPress: () {
                          ConnectionStatusListener.isOnHomePage = false;
                          Get.to(() =>  SettingsScreen());
                        }
    ),
                  // const SizedBox(height: 15),
                  // AElevatedButton(
                  //   title: "Add Contact",
                  //   onPress: () {
                  //     Get.dialog(
                  //        AddContactScreen(),
                  //     );
                  //   },
                  // ),
                  // const SizedBox(height: 15),
                  // AElevatedButton(
                  //     title: "Create Group",
                  //     onPress: () {
                  //       Get.to( () => CreateGroupScreen());
                  //     }),
                  const SizedBox(height: 15),
                  Obx(() {
                    return AElevatedButton(
                      bgColor: inAppPurchaseUtils.isSubscriptionActive.value
                          ? AColors.dark
                          : Colors.grey,
                      title: "Location Trail",
                      onPress: inAppPurchaseUtils.isSubscriptionActive.value
                          ? () {
                        locationManageController.getFriends(
                            Get
                                .find<AuthController>()
                                .userModel
                                .value
                                .id);
                        Get.to(() =>
                            LocationManageScreen(
                                locationManageController: locationManageController));
                        ConnectionStatusListener.isOnHomePage = false;

                        // Get.dialog(
                        //   LocationTrailScreen(),
                        // );
                      }
                          : goToSubscription,
                    );
                  }),
                ],
              ),
            ),
          ),
          const WarningCircleIcon(),
        ],
      ),
    );
  }
}
