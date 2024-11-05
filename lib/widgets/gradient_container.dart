import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer({
    super.key,
    this.child,
    this.mTop,
  });

  final Widget? child;
  final double? mTop;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: mTop ?? 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.center,
          end: Alignment.bottomCenter,
          // transform: GradientRotation(45),
          colors: [
            AColors.primary,
            AColors.primary,
            AColors.primary,
            // AColors.secondary,
          ],
        ),
      ),
      child: child,
    );
  }
}
