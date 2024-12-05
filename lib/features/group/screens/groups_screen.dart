import 'package:alarm_app/features/group/screens/create_group_screen.dart';
import 'package:alarm_app/features/settings/screens/widgets/group_row_widget.dart';
import 'package:alarm_app/widgets/background_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../controller/group_controller.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key, required this.groupController});

  final GroupController groupController;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      appBarTitle: "Groups",
        trailingData: Icons.group_add_rounded,
        onClick: (){
        Get.to(()=> CreateGroupScreen(groupController: groupController));
        },
        widgets: [

      SizedBox(
        height: Get.height,
        child: GetBuilder<GroupController>(
            builder: (_,) {

          return groupController.allGroups.isEmpty? Padding(padding: EdgeInsets.only(top: 100, left: Get.width * 0.25), child: Text("No group created yet!",style: TextStyle(
              color: AColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600),)): ListView.builder(
              itemCount: groupController.allGroups.length,
              itemBuilder: (context, index) {
                return GroupRowWidget(
                    groupModel: groupController.allGroups[index], index: index);
              });
        }),
      )
    ],
    );
  }
}
