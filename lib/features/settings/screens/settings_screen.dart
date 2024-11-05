import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/door/screens/door_screen.dart';
import 'package:alarm_app/features/notification/screens/notification_screen.dart';
import 'package:alarm_app/features/plans/screens/plans_screen.dart';

import 'package:alarm_app/features/settings/screens/widgets/primary_group.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../contact/screens/add_contact_screen.dart';
import '../../group/screens/create_group_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        // actions: const [Icon(Icons.person), SizedBox(width: 10)],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GradientContainer(
            mTop: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                   Center(
                    child: Text(
                      Supabase.instance.client.auth.currentUser?.phone?? "",
                      style: TextStyle(
                          color: AColors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 25),
                  AElevatedButton(
                      title: "Subscribe",
                      onPress: () {
                      Get.to(PaymentScreen());
                      }),
                  const SizedBox(height: 15),
                  AElevatedButton(
                      title: "Contacts",
                      onPress: () {
                        Get.to(
                          AddContactScreen(),
                        );
                        // Get.to(DoorScreen());
                      }),
                  const SizedBox(height: 15),
                  AElevatedButton(
                      title: "Groups",
                      onPress: () {
                        Get.to( () => CreateGroupScreen());
                        // Get.to(const SettingsScreen());
                      }),
                  const SizedBox(height: 15),
                  const PrimaryGroup(title: "Primary Indoor Group"),
                  const SizedBox(height: 15),
                  const PrimaryGroup(title: "Primary Outdoor Group"),
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
