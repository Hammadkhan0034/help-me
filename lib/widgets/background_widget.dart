import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.widget});
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GradientContainer(mTop: 110, child: widget),
        const WarningCircleIcon()
      ],
    );
  }
}
