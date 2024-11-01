import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../widgets/elevated_button.dart';
import '../../../widgets/gradient_container.dart';
import '../../../widgets/warning_circle_icon.dart';
import '../controller/auth_controller.dart';
import '../widget/name_field_Widget.dart';
import '../widget/phone_auth_field_Widget.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    NameFieldWidget(controller: authController.nameController),
                    SizedBox(height: 10),
                    PhoneAuthFieldWidget(
                      onChanged: (PhoneNumber value) {
                        authController.phoneNumber.value = value.completeNumber;
                        if (kDebugMode) {
                          print(value.completeNumber);
                        }
                      },
                    ),
                    const SizedBox(height: 35),
                    AElevatedButton(
                      borderRadius: 25,
                      title: "Send Verification",
                      onPress: () {
                        authController.signUp();

                        // if (_formKey.currentState!.validate()) {
                        //   print("Phone number validated, proceeding with sign-up");
                        // } else {
                        //   print("Phone number validation failed");
                        // }
                      },
                    ),
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
