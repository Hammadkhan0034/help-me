import 'package:alarm_app/features/tutorial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class NotificationIconWithCount extends StatelessWidget {
  const NotificationIconWithCount({
    super.key,
    required this.onPress,
  });


  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Stack(
        children: [
          const SizedBox(
            width: 60,
            height: 50,
            child: Icon(
              Icons.notifications,

              size: 30,
            ),
          ),
          // Positioned(
          //   right: 1,
          //   top: 1,
          //   child: Container(
          //       padding: const EdgeInsets.all(5),
          //       decoration: BoxDecoration(
          //         color: Colors.red,
          //         borderRadius: BorderRadius.circular(4),
          //       ),
          //       child: const Center(
          //         child: Text(
          //           "10",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 10,
          //           ),
          //         ),
          //       )),
          // )
        ],
      ),
    );
  }
}
