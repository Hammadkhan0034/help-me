import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/connection_listener.dart';

class BackgroundWidget extends StatelessWidget {
   BackgroundWidget(
      {super.key,
      required this.widgets,
      required this.appBarTitle,
      this.trailingData,
      this.onClick, this.scrollController});
  final List<Widget> widgets;
  final String appBarTitle;
  final IconData? trailingData;
  final VoidCallback? onClick;
  final  ScrollController? scrollController;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (val,res){
        ConnectionStatusListener.isOnHomePage = true;

      },
      child: Scaffold(
        backgroundColor: AColors.primary,
        appBar: AppBar(
          elevation: 5,
          leading: InkWell(
              onTap: Get.back, child: const Icon(Icons.arrow_back_ios_new)),
          title: Text(
            appBarTitle,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            InkWell(
              onTap: onClick,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  trailingData,
                  color: Colors.black,
                ),
              ),
            )
          ],
          centerTitle: true,
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WarningCircleIcon(),
              ...widgets,
              // GradientContainer(mTop: 110, child: widgets),
            ],
          ),
        ),
      ),
    );
  }
}
