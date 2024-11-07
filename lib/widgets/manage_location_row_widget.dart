import 'package:alarm_app/features/trail_location/controller/LocationManageController.dart';
import 'package:alarm_app/models/friends_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/colors.dart';

class ManageLocationRowWidget extends StatelessWidget {
  const ManageLocationRowWidget(
      {super.key, required this.friendsProfileModel, required this.index});
  final FriendsProfileModel friendsProfileModel;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.circle, size: 10, color: AColors.white),
                  ), // The dot icon before the name
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Get.find<LocationManageController>()
                          .openLocation(friendsProfileModel);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: Get.width * 0.45,
                            child: Text(
                              friendsProfileModel.editedName ??
                                  friendsProfileModel.nameInContacts,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            )),
                        Text(
                          friendsProfileModel.phone ?? "",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Checkbox(
                  value: friendsProfileModel.canSeeLocation,
                  checkColor: Colors.red,
                  activeColor: Colors.white,
                  side: WidgetStateBorderSide.resolveWith((states) {
                    return BorderSide(
                        color: Colors.white,
                        width: 1.5); // Inactive border color
                    // Active border color
                  }),
                  onChanged: (val) {
                    Get.find<LocationManageController>()
                        .changeFriendLocationPermission(
                            index, val, friendsProfileModel);
                  })
              // IconButton(
              //   icon: const Icon(Icons.add, color: Colors.white),
              //   onPressed: () async {},
              // ),
            ],
          ),
          const Divider(
            color: Colors.white,
            indent: 1,
            endIndent: 1,
            thickness: 2,
          )
        ],
      ),
    );
  }
}
