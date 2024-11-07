import 'package:alarm_app/common/widgets/rounded_container.dart';
import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/plans/controllers/payment_controller.dart';
import 'package:alarm_app/features/plans/screens/plans_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YearlyPlan extends StatelessWidget {
  const YearlyPlan({
    super.key,
    required this.paymentController,
  });

  final PaymentController paymentController;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Card(
          elevation: 5,
          color: AColors.primary,
          child: MRoundedContainer(
            isGradient: paymentController.showYearlyPlan.value,
            bgColor: Color(0xffE5E5E5),
            padding: 10,
            child: Column(
              children: [
                MPlanTile(
                  onTap: () {
                    paymentController.showYearlyPlan.value =
                        !paymentController.showYearlyPlan.value;
                  },
                  up: paymentController.showYearlyPlan.value,
                  title: 'Yearly Plan',
                ),
                if (paymentController.showYearlyPlan.value)
                  Column(
                    children: [
                      const Divider(color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "There is a fee of 1 RM only per month to be paid 12 RM for 1 year subscription if you want to use both the Indoor and Outdoor functions.",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("12 RM/Year",
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
                                elevation: 3),
                            child: const Text(
                              "Subscribe",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            onPressed: () {
                              paymentController.makePayment("12");
                              // settingsController.updateAccountPrivacy();
                            },
                          ),
                        ],
                      )
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
