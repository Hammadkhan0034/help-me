import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
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
                AElevatedButton(
                    bgColor: AColors.primary,
                    title: "OK",
                    onPress: Get.back)
              ],
            ),
          ),
          // Positioned(
          //   top: 0,
          //   right: 0,
          //   child: IconButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     icon: const Icon(
          //       Icons.close,
          //       color: AColors.dark,
          //     ),
          //   )
        ],
      ),
    );
  }
}
