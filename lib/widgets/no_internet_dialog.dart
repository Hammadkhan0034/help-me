import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoInternetDialog extends StatelessWidget {

  final void Function() onPress;
  const NoInternetDialog({
    super.key, required this.onPress,
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
                const Image(
                  image: AssetImage("assets/noInternet.png"),
                  height: 100,
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
                    "No internet connection found Check your connection and try again"),
                const Spacer(),
                AElevatedButton(
                    bgColor: AColors.primary,
                    title: "Try Again",
                    onPress: onPress)
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
          //   ),
          // )
        ],
      ),
    );
  }
}
