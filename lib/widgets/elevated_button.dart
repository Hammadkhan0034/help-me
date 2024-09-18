import 'package:alarm_app/constants/colors.dart';
import 'package:flutter/material.dart';

class AElevatedButton extends StatelessWidget {
  const AElevatedButton({
    super.key,
    required this.title,
    required this.onPress,
    this.bgColor = AColors.dark,
    this.padding,
  });

  final String title;
  final Color bgColor;
  final double? padding;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 20,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          backgroundColor: bgColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
