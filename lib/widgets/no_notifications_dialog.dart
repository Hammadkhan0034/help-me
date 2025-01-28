import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoNotificationsDialog extends StatelessWidget {
  const NoNotificationsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: AColors.white.withOpacity(.7),
      content: Stack(
        children: [
          ARoundedContainer(
            padding: 20,
            bgColor: Colors.transparent,
            height: 300,
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_off_outlined,
                  size: 50,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Oh No!",
                  style: TextStyle(
                      fontSize: 30,
                      color: AColors.dark,
                      fontWeight: FontWeight.w600),
                ),
                const Text(
                    textAlign: TextAlign.center,
                    "Notifications are disabled. Please go to setting and enable notification to fully utilize the app."),
                const Spacer(),
                AElevatedButtonForNotification(
                    bgColor: AColors.primary, title: "OK", onPress: Get.back)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionDialog extends StatelessWidget {
  const SubscriptionDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: AColors.white.withOpacity(.7),
      content: Stack(
        children: [
          ARoundedContainer(
            padding: 20,
            bgColor: Colors.transparent,
            height: 250,
            child: Column(
              children: [
                const Icon(
                  Icons.subscriptions,
                  size: 50,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Subscription!",
                  style: TextStyle(
                      fontSize: 30,
                      color: AColors.dark,
                      fontWeight: FontWeight.w600),
                ),
                const Text(
                    textAlign: TextAlign.center,
                    "Please contact the support on this number 0183912457 to upgrade your subscription."),
                const Spacer(),
                AElevatedButtonForNotification(
                    bgColor: AColors.primary, title: "OK", onPress: Get.back)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AskPermissionDialog extends StatelessWidget {
  const AskPermissionDialog({
    super.key,
    required this.title,
    required this.description,
  });

  final String title, description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: AColors.white.withOpacity(.7),
      content: Stack(
        children: [
          ARoundedContainer(
            padding: 20,
            bgColor: Colors.transparent,
            height: 300,
            child: Column(
              children: [
                const Icon(
                  Icons.notifications_off_outlined,
                  size: 50,
                ),
                Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TextStyle(
                      fontSize: 30,
                      color: AColors.dark,
                      fontWeight: FontWeight.w600),
                ),
                Text(textAlign: TextAlign.center, description),
                const Spacer(),
                AElevatedButtonForNotification(
                    bgColor: AColors.primary, title: "OK", onPress: Get.back)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AElevatedButtonForNotification extends StatelessWidget {
  const AElevatedButtonForNotification({
    super.key,
    required this.title,
    required this.onPress,
    this.bgColor = AColors.dark,
    this.padding,
    this.borderRadius = 10.0,
    this.width = double.infinity, // Default border radius
  });

  final double width;
  final String title;
  final Color bgColor;
  final double? padding;
  final double borderRadius; // Optional borderRadius with default value
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                borderRadius), // Apply custom border radius
          ),
          padding: EdgeInsets.all(padding ?? 10),
        ),
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
