import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';

class AElevatedButton extends StatelessWidget {
  const AElevatedButton({
    super.key,
    required this.title,
    required this.onPress,
    this.bgColor = AColors.dark,
    this.padding,
    this.borderRadius = 10.0, // Default border radius
  });

  final String title;
  final Color bgColor;
  final double? padding;
  final double borderRadius; // Optional borderRadius with default value
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius), // Apply custom border radius
          ),
          padding: EdgeInsets.all(padding ?? 10),
        ),
        onPressed: onPress,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
