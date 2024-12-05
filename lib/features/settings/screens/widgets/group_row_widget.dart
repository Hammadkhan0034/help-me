import 'package:alarm_app/features/group/controller/group_controller.dart';
import 'package:alarm_app/features/group/screens/create_group_screen.dart';
import 'package:alarm_app/features/trail_location/controller/LocationManageController.dart';
import 'package:alarm_app/models/friends_profile_model.dart';
import 'package:alarm_app/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/colors.dart';


class GroupRowWidget extends StatelessWidget {
  const GroupRowWidget(
      {super.key, required this.groupModel, required this.index});
  final GroupModel groupModel;
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(Icons.circle, size: 10, color: AColors.white),
              ), // The dot icon before the name
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Get.to(()=>CreateGroupScreen(groupController: Get.find<GroupController>(),groupModel: groupModel,title: "Update Group"));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: Get.width * 0.45,
                        child: Text(
                          groupModel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )),
                    Text(
                      "Type: ${groupModel.type}, Members: ${groupModel.members.length}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  Get.find<GroupController>().deleteGroup(groupModel, index);
                },
                child:Icon(Icons.delete,color: Colors.white)
              )
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
