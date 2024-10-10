import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/contact/screens/add_contact_screen.dart';
import 'package:alarm_app/features/door/screens/door_screen.dart';
import 'package:alarm_app/features/group/screens/create_group_screen.dart';
import 'package:alarm_app/features/notification/screens/notification_screen.dart';
import 'package:alarm_app/features/settings/screens/settings_screen.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/no_internet_dialog.dart';
import 'package:alarm_app/widgets/notification_icon_with_count.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpMeScreen extends StatelessWidget {
  const HelpMeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: NotificationIconWithCount(
          onPress: () {
            Get.to(const NotificationScreen());
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
                        // Get.to(const NotificationScreen());
                      }),
                  const SizedBox(height: 15),
                  AElevatedButton(
                      title: "DOOR",
                      onPress: () {
                        Get.to(DoorScreen());
                      }),
                  const SizedBox(height: 15),
                  AElevatedButton(
                      title: "SETTINGS",
                      onPress: () {
                        Get.to(const SettingsScreen());
                      }),
                  const SizedBox(height: 15),
                  AElevatedButton(
                    title: "Add Contact",
                    onPress: () {
                      Get.dialog(
                         AddContactScreen(),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  AElevatedButton(
                      title: "Create Group",
                      onPress: () {
                        Get.to( CreateGroupScreen());
                      }),
                  // const SizedBox(height: 15),
                  // AElevatedButton(
                  //   title: "Show Alert",
                  //   onPress: () {
                  //     Get.dialog(
                  //       const NoInternetDialog(),
                  //     );
                  //   },
                  // ),
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
