import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ACircularContainer extends StatelessWidget {
  const ACircularContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 200,

      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(

            width: Get.width,
            height: 120,
            color: Colors.white,
          ),
          Container(
              height: 200,
              width: 200,margin: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 20, spreadRadius: .5),
                ],
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: child),
        ],
      ),
    );
  }
}
