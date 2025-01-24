import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../widgets/elevated_button.dart';
import '../../../widgets/gradient_container.dart';
import '../../../widgets/warning_circle_icon.dart';
import '../controller/auth_controller.dart';
import '../widget/name_field_Widget.dart';
import '../widget/phone_auth_field_Widget.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.15),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: GradientContainer(
                mTop: 110,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NameFieldWidget(
                            controller: authController.nameController),
                        SizedBox(height: 10),
                        PhoneAuthFieldWidget(
                          onChanged: (PhoneNumber value) {
                            authController.phoneNumber.value =
                                value.phoneNumber!;
                          },
                        ),
                        const SizedBox(height: 35),
                        AElevatedButton(
                          borderRadius: 25,
                          title: "Send Verification",
                          onPress: () {
                            if (_formKey.currentState!.validate()) {
                              authController.signUp();
                              print(
                                  "Phone number validated, proceeding with sign-up");
                            } else {
                              print("Phone number validation failed");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
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
