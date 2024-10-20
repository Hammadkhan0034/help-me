import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';

class NotificationWidget extends StatelessWidget {
  final String title;

  const NotificationWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.8,
      child:  Text(
        title,
        style: TextStyle(
          fontSize:Get.width*0.04,
          fontWeight: FontWeight.w600,
          color: AColors.white,
        ),
      ),
    );
  }
}
