import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';

class MRoundedContainer extends StatelessWidget {
  const MRoundedContainer({
    super.key,
    required this.child,
    this.padding,
    this.bgColor,
    this.height,
    this.width,
    this.borderRadius,
    this.onTap,
    this.isGradient = false,
  });

  final Widget child;
  final double? padding;
  final Color? bgColor;
  final double? height;
  final double? borderRadius;
  final double? width;
  final VoidCallback? onTap;
  final bool isGradient;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: isGradient
              ? LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    AColors.primary,
                    AColors.primary,

                    // AColors.secondary,
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(borderRadius ?? 15),
        ),
        padding: EdgeInsets.all(padding ?? 0.0),
        child: InkWell(onTap: onTap, child: child),
      ),
    );
  }
}
