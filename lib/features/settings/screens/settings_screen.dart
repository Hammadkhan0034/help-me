import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/core/subscription_controller.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/features/group/controller/group_controller.dart';
import 'package:alarm_app/features/group/screens/groups_screen.dart';
import 'package:alarm_app/features/plans/screens/plans_screen.dart';
import 'package:alarm_app/features/settings/screens/widgets/primary_group.dart';
import 'package:alarm_app/widgets/background_widget.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../utils/connection_listener.dart';
import '../../../widgets/notification_controller_widget.dart';
import '../../contact/screens/add_contact_screen.dart';
import '../../group/screens/create_group_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final InAppPurchaseUtils inAppPurchaseUtils = Get.find<InAppPurchaseUtils>();

  void goToSubscription(){
    Get.to(()=> PaymentScreen());
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val, res) {
        ConnectionStatusListener.isOnHomePage = true;
      },
      child: GetBuilder<GroupController>(builder: (logic) {
        return BackgroundWidget(
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
            Obx(() {
              return !Get
                  .find<InAppPurchaseUtils>()
                  .isSubscriptionActive
                  .value ? SizedBox.shrink() : AElevatedButton(
                  title: "Subscribe",
                  onPress: () {
                    Get.to(PaymentScreen());
                  });
            }).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            Obx(() {
              return AElevatedButton(
                  bgColor: inAppPurchaseUtils.isSubscriptionActive.value
                      ? AColors.dark
                      : Colors.grey,
                  title: "Contacts",
                  onPress:inAppPurchaseUtils.isSubscriptionActive.value? () {
                    Get.to(
                      AddContactScreen(
                        addContactController: Get.find<
                            ContactController>(),
                      ),
                    );
                    // Get.to(DoorScreen());
                  }: goToSubscription);
            }).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            Obx(() {
              return AElevatedButton(
                  bgColor: inAppPurchaseUtils.isSubscriptionActive.value
                      ? AColors.dark
                      : Colors.grey,
                  title: "Groups",
                  onPress: inAppPurchaseUtils.isSubscriptionActive.value?() {
                    Get.to(() =>
                        GroupsScreen(
                          groupController: Get.find<GroupController>(),));
                    // Get.to(const SettingsScreen());
                  }: goToSubscription);
            }).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            PrimaryGroup(title: "Primary Indoor Group", groups: Get
                .find<GroupController>()
                .indoorGroups, onChange: Get
                .find<AuthController>()
                .updatePrimaryIndoorGroup, selectedGroup: Get
                .find<GroupController>()
                .primaryIndoor,).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            PrimaryGroup(title: "Primary Outdoor Group", groups: Get
                .find<GroupController>()
                .outdoorGroups, onChange: Get
                .find<AuthController>()
                .updatePrimaryOutdoorGroup, selectedGroup: Get
                .find<GroupController>()
                .primaryOutdoor).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),
            NotificationControllerWidget().paddingSymmetric(horizontal: 20),

            const SizedBox(height: 15),

        AElevatedButton(

        title: "Delete Account",
        onPress: Get
            .find<AuthController>()
            .deleteAccount,).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 15),

          ],);
      }),

    );
  }
}
