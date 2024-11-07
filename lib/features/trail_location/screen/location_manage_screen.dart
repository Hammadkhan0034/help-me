import 'package:alarm_app/features/trail_location/controller/LocationManageController.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/manage_location_row_widget.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationManageScreen extends StatelessWidget {
  const LocationManageScreen(
      {super.key, required this.locationManageController});

  final LocationManageController locationManageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          "Location Permissions",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GradientContainer(
            mTop: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
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
                  return Expanded(
                      child: controller.friendsList.isEmpty
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
                              itemBuilder: (context, index) {
                                return ManageLocationRowWidget(
                                    friendsProfileModel:
                                        controller.friendsList[index],
                                    index: index);
                              }));
                })
              ],
            ),
          ),
          const WarningCircleIcon()
        ],
      ),
    );
  }
}
