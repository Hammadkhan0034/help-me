import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';

class ARoundedContainer extends StatelessWidget {
  const ARoundedContainer({
    super.key,
    this.bgColor = AColors.dark,
    this.child,
    this.height,
    this.width,
    this.padding = 5,
  });

  final Color bgColor;
  final Widget? child;
  final double? height;
  final double? width;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: bgColor,
      ),
      child: child,
    );
  }
}
