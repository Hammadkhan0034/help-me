import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/circular_container.dart';
import 'package:flutter/material.dart';

class WarningCircleIcon extends StatelessWidget {
  const WarningCircleIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      right: 1,
      top: 10,
      left: 1,
      child: ACircularContainer(
        child: Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: AColors.primary,
            child: Text(
              "!",
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
          ),
        ),
      ),
    );
  }
}
