import 'package:alarm_app/common/widgets/rounded_container.dart';
import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/plans/controllers/payment_controller.dart';
import 'package:alarm_app/features/plans/screens/plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicPlan extends StatelessWidget {
  const BasicPlan({
    super.key,
    required this.paymentController,
  });

  final PaymentController paymentController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MRoundedContainer(
        isGradient: paymentController.showBasicPlan.value,
        bgColor: Color(0xffE5E5E5),
        padding: 10,
        child: Column(
          children: [
            MPlanTile(
              onTap: () {
                paymentController.showBasicPlan.value =
                !paymentController.showBasicPlan.value;
              },
              up: paymentController.showBasicPlan.value,
              title: 'Basic Plan',
            ),
            if (paymentController.showBasicPlan.value)
              Column(
                children: [
                  const Divider(color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Pro account gives you freedom with uploading HD videos and can also meet all your business needs apasih kamu",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("100/day",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                              color: Colors.white)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 3
                        ),
                        child: const Text(
                          "Subscribe",
                          style: TextStyle(fontWeight: FontWeight.w600, color: AColors.secondary),
                        ),
                        onPressed: () {
                          // settingsController.updateAccountPrivacy();
                        },
                      ),
                    ],
                  )
                ],
              )
          ],
        ),
      );
    });
  }
}