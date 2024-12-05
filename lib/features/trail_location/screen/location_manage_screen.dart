import 'package:alarm_app/features/trail_location/controller/LocationManageController.dart';
import 'package:alarm_app/widgets/background_widget.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/manage_location_row_widget.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationManageScreen extends StatelessWidget {
  const LocationManageScreen(
      {super.key, required this.locationManageController});

  final LocationManageController locationManageController;

  @override
  Widget build(BuildContext context) {
    return  BackgroundWidget(
        trailingData: Icons.help_outline,
        onClick: (){
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Notification',
            desc: 'You can tap on the username to see his location and check mark the user to allow him to see your location',
            btnCancelOnPress: () {},
            btnCancel: null,
            transitionAnimationDuration: Duration(microseconds: 0),
            btnOkOnPress: () {},
          ).show();
        },
        widgets: [ SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Text(
              "Location Enabled",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Obx(() {
              return Checkbox(
                  value: locationManageController.isTracking.value,
                  checkColor: Colors.red,
                  activeColor: Colors.white,
                  side: WidgetStateBorderSide.resolveWith((states) {
                    return BorderSide(
                        color: Colors.white,
                        width: 1.5); // Inactive border color
                    // Active border color
                  }),
                  onChanged: locationManageController
                      .changeLocationPermission);
            })
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: const Divider(
          color: Colors.white,
          indent: 1,
          endIndent: 1,
          thickness: 2,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
        child: Text(
          "Friends Permissions :",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      GetBuilder<LocationManageController>(builder: (controller) {
        return controller.friendsList.isEmpty
            ? Center(
          child: Text(
            "No Friends Added",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17),
          ),
        )
            : ListView.builder(
            itemCount: controller.friendsList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ManageLocationRowWidget(
                  friendsProfileModel:
                  controller.friendsList[index],
                  index: index);
            });
      })
    ], appBarTitle: "Location Permissions")
    ;
  }
}
