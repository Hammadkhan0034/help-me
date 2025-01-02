import 'package:alarm_app/core/subscription_controller.dart';
import 'package:alarm_app/features/plans/controllers/payment_controller.dart';
import 'package:alarm_app/features/plans/screens/widgets/yearly_plan.dart';
import 'package:alarm_app/features/privacy_policy_and%20_eula%20sidget.dart';
import 'package:alarm_app/widgets/background_widget.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final PaymentController paymentController = Get.put(PaymentController());
  final subscriptionController = Get.find<InAppPurchaseUtils>();

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
        appBarTitle: "Plans",
        widgets: [
          // BasicPlan(paymentController: paymentController),
          SizedBox(height: 50),
          // DailyPlan(paymentController: paymentController),
          // SizedBox(height: 15),
          // MonthlyPlan(paymentController: paymentController),
          // SizedBox(height: 15),
          YearlyPlan(paymentController: paymentController),
          PrivacyPolicyAndEula(),


            Obx(() {
              return subscriptionController.isSubscriptionActive.value ?  Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
                child: AElevatedButton(
                    title: "Restore Purchase", onPress: () {
                  Get.find<InAppPurchaseUtils>().restorePurchases();
                }),
              ): SizedBox.shrink();
            }),
        ]
    );
  }
}

class MPlanTile extends StatelessWidget {
  const MPlanTile({
    super.key,
    required this.title,
    required this.onTap,
    this.up = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool up;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(fontWeightDelta: 2, color: up ? Colors.white : null),
            ),
            const Spacer(),
            Icon(
              color: up ? Colors.white : null,
              up ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
              size: 50,
            )
          ],
        ),
      ),
    );
  }
}
