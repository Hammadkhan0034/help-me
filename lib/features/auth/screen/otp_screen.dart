import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/auth/widget/otp_field.dart';
import 'package:alarm_app/features/auth/widget/phone_auth_field_Widget.dart';
import 'package:alarm_app/features/contact/screens/add_contact_screen.dart';
import 'package:alarm_app/features/door/screens/door_screen.dart';
import 'package:alarm_app/features/group/screens/create_group_screen.dart';
import 'package:alarm_app/features/help/screens/help_me_screen.dart';
import 'package:alarm_app/features/notification/screens/notification_screen.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/no_internet_dialog.dart';
import 'package:alarm_app/widgets/notification_icon_with_count.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/phone_number.dart';
class OtpScreen extends StatelessWidget {
   OtpScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,)),
        // centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.05),
        child: Stack(
          children: [
            GradientContainer(
              mTop: 110,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PinField( onCompleted: (pin) {
                      authController.verifyOtp(pin);
                      print("OTP Entered: $pin");
                      // ctrl.verifyPin(pin);
                    },),
                    // SizedBox(
                    //   height: 35,
                    // ),
                    // AElevatedButton(
                    //   borderRadius: 25,
                    //   title: "Enter",
                    //   onPress: () {},
                    // )
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