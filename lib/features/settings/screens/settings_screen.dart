import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/core/subscription_controller.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/features/group/controller/group_controller.dart';
import 'package:alarm_app/features/group/screens/groups_screen.dart';
import 'package:alarm_app/features/plans/screens/plans_screen.dart';
import 'package:alarm_app/features/settings/screens/widgets/primary_group.dart';
import 'package:alarm_app/features/tutorial_controller.dart';
import 'package:alarm_app/widgets/background_widget.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/connection_listener.dart';
import '../../../widgets/notification_controller_widget.dart';
import '../../contact/screens/add_contact_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final InAppPurchaseUtils inAppPurchaseUtils = Get.find<InAppPurchaseUtils>();
  final TutorialController tutorialController = Get.find<TutorialController>();
  void goToSubscription() {
    Get.to(() => PaymentScreen());
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tutorialController.showSettingTutorial(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, res) {
        ConnectionStatusListener.isOnHomePage = true;
      },
      child: GetBuilder<GroupController>(builder: (logic) {
        return BackgroundWidget(
          scrollController: tutorialController.scrollController,
          appBarTitle: "Settings",
          widgets: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                Supabase.instance.client.auth.currentUser?.phone ?? "",
                style: TextStyle(
                    color: AColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 25),
            AElevatedButton(
                key: tutorialController.subscribeKey,
                title: "Subscribe",
                onPress: () {
                  Get.to(PaymentScreen());
                }).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            Obx(() {
              return AElevatedButton(
                  key: tutorialController.contactsKey,
                  bgColor: inAppPurchaseUtils.isSubscribed()
                      ? AColors.dark
                      : Colors.grey,
                  title: "Contacts",
                  onPress: inAppPurchaseUtils.isSubscribed()
                      ? () {
                          Get.to(
                            AddContactScreen(
                              addContactController:
                                  Get.find<ContactController>(),
                            ),
                          );
                          // Get.to(DoorScreen());
                        }
                      : goToSubscription);
            }).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            Obx(() {
              return AElevatedButton(
                  key: tutorialController.groupsKey,
                  bgColor: inAppPurchaseUtils.isSubscribed()
                      ? AColors.dark
                      : Colors.grey,
                  title: "Groups",
                  onPress: inAppPurchaseUtils.isSubscribed()
                      ? () {
                          Get.to(() => GroupsScreen(
                                groupController: Get.find<GroupController>(),
                              ));
                          // Get.to(const SettingsScreen());
                        }
                      : goToSubscription);
            }).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            PrimaryGroup(
              key: tutorialController.primaryGroupKey,
              title: "Primary Indoor Group",
              groups: Get.find<GroupController>().indoorGroups,
              onChange: Get.find<AuthController>().updatePrimaryIndoorGroup,
              selectedGroup: Get.find<GroupController>().primaryIndoor,
            ).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            PrimaryGroup(
                    key: tutorialController.primaryOutdoorKey,
                    title: "Primary Outdoor Group",
                    groups: Get.find<GroupController>().outdoorGroups,
                    onChange:
                        Get.find<AuthController>().updatePrimaryOutdoorGroup,
                    selectedGroup: Get.find<GroupController>().primaryOutdoor)
                .paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            NotificationControllerWidget(
              key: tutorialController.notificationStatusKey,
            ).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            AElevatedButton(
              key: tutorialController.deleteAccountKey,
              title: "Delete Account",
              onPress: Get.find<AuthController>().deleteAccount,
            ).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            AElevatedButton(
              // key: tutorialController.deleteAccountKey,
              title: "Privacy Policy",
              onPress: Get.find<AuthController>().privacyPolicy,
            ).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 30),
          ],
        );
      }),
    );
  }
}
