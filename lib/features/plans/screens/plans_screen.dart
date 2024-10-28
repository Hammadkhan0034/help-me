import 'package:alarm_app/common/widgets/rounded_container.dart';
import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/plans/controllers/payment_controller.dart';
import 'package:alarm_app/features/plans/screens/widgets/basic_plan.dart';
import 'package:alarm_app/features/plans/screens/widgets/daily_plan.dart';
import 'package:alarm_app/features/plans/screens/widgets/monthly_plan.dart';
import 'package:alarm_app/features/plans/screens/widgets/yearly_plan.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});
  final PaymentController paymentController = Get.put(PaymentController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Plans"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            BasicPlan(paymentController: paymentController),
            SizedBox(height: 15),
            DailyPlan(paymentController: paymentController),
            SizedBox(height: 15),
            MonthlyPlan(paymentController: paymentController),
            SizedBox(height: 15),
            YearlyPlan(paymentController: paymentController)
          ],
        ),
      ),
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
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(fontWeightDelta: 2, color:up? Colors.white:null),
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
