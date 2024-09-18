import 'package:flutter/material.dart';

class ACircularContainer extends StatelessWidget {
  const ACircularContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 200,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black38, blurRadius: 20, spreadRadius: .5),
          ],
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: child);
  }
}
