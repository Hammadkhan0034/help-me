import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/auth/widget/phone_auth_field_Widget.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.15),
        child: Stack(
          children: [
            GradientContainer(
              mTop: 110,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhoneAuthFieldWidget(
                      onChanged: (PhoneNumber value) {
                        if (kDebugMode) {
                          print(value.completeNumber);
                          authController.phoneNumber=value.completeNumber;


                        }
                      },
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    AElevatedButton(
                      borderRadius: 25,
                      title: "Send Verification",
                      onPress: () {
                        print("Printed the isgn");
                      authController.signUp();
                      },
                    )
                  ],
                ),
              ),
            ),
            const WarningCircleIcon(),
          ],
        ),
      ),
    );
  }
}
