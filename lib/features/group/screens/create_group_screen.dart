import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/group/controller/group_controller.dart';
import 'package:alarm_app/features/group/widget/door_mode_widget.dart';
import 'package:alarm_app/models/group_model.dart';
import 'package:alarm_app/widgets/background_widget.dart';
import 'package:alarm_app/widgets/circular_container.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contact/add_contacts_controller/add_contact_controller.dart';


class CreateGroupScreen extends StatelessWidget {
  CreateGroupScreen(
      {super.key, required this.groupController, this.groupModel, this.title = "Create Group"}) {
    groupController.resetCreateData();
    if (groupModel != null) {
      groupController.setSelectedGroup(groupModel!);
    }
  }

  final GroupController groupController;
  final GroupModel? groupModel;
  final String title;
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
        scrollController: scrollController,
        widgets: [
          const SizedBox(height: 20),
          const Text(
            "Group Name",
            style: TextStyle(
                color: AColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ).paddingSymmetric(horizontal: 20),
          const SizedBox(height: 5),
          TextField(
            controller: groupController.name,
            style: const TextStyle(
              color: AColors.white, // Set the text color to white
            ),
            cursorColor: AColors.white, // Set the cursor color to white
            decoration: InputDecoration(
              hintText: "Enter Group Name",
              fillColor: AColors.darkGrey.withOpacity(0.5),
              filled: true,
              hintStyle: TextStyle(
                color: AColors.white.withOpacity(0.5),
                fontSize: 16,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(
                  color: AColors.white,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: AColors.white),
              ),
            ),
          ).paddingSymmetric(horizontal: 20),
          Obx(() {
            return groupController.groupType.value == "Outdoor"? SizedBox(height: 10,) : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Indoor Address",
                  style: TextStyle(
                      color: AColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ).paddingSymmetric(horizontal: 20),
                const SizedBox(height: 5),
                TextField(
                  controller: groupController.defaultAddress,
                  style: const TextStyle(
                    color: AColors.white, // Set the text color to white
                  ),
                  cursorColor: AColors.white, // Set the cursor color to white
                  decoration: InputDecoration(
                    hintText: "Enter Indoor Address",
                    fillColor: AColors.darkGrey.withOpacity(0.5),
                    filled: true,
                    hintStyle: TextStyle(
                      color: AColors.white.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: AColors.white,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: AColors.white),
                    ),
                  ),
                ).paddingSymmetric(horizontal: 20),
                const SizedBox(height: 10),

              ],);
          }),
          const Text(
            "Added Contacts:",
            style: TextStyle(
                color: AColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ).paddingSymmetric(horizontal: 20),
          const SizedBox(height: 5),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupController
                  .addContactController.requestedFriends.length,
              itemBuilder: (context, index) {
                final contact = groupController
                    .addContactController.requestedFriends[index];
                return ListTile(
                  leading: SizedBox(
                    width: Get.width * 0.30,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      contact.editedName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AColors.white,
                          fontSize: 16),
                    ),
                  ),
                  title: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    contact.friendPhone.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AColors.white,
                        fontSize: 16),
                  ),
                  trailing: contact.requestStatus == 1 ? GestureDetector(
                      onTap: () {
                        groupController.addToGroupContacts(contact);
                      },
                      child: Icon(Icons.add, color: Colors.white,)) : Text(
                      "Pending", style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
                );
              },
            );
          }).paddingSymmetric(horizontal: 20),
          const SizedBox(height: 10),
          const Text(
            "Group Contacts:",
            style: TextStyle(
                color: AColors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ).paddingSymmetric(horizontal: 20),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupController.groupContacts.length,
              itemBuilder: (context, index) {
                final groupContact = groupController.groupContacts[index];
                return ListTile(
                  leading: SizedBox(
                    width: Get.width * 0.30,
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      groupContact.editedName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AColors.white,
                          fontSize: 16),
                    ),
                  ),
                  title: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    groupContact.friendPhone.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AColors.white,
                        fontSize: 16),
                  ),
                  trailing: GestureDetector(
                      onTap: () {
                        groupController.removeContactFromGroup(groupContact.id);
                      },
                      child: Icon(Icons.delete, color: Colors.white,)),
                );
              },
            ).paddingSymmetric(horizontal: 20);
          }),
          const SizedBox(height: 10),
          SizedBox(height: 120,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  color: AColors.darkGrey,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() {
                        return DoorModeWidget(
                          label: groupController.groupType.value,
                          value: groupController.groupType
                              .value, // Default value from controller
                          onChanged: (newValue) {
                            // Handle the dropdown selection change
                            groupController.updateOption(newValue);
                          },
                        );
                      }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AColors.dark,
                    ),
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Door",
                          style: TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 20),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: AElevatedButton(title: "Save", onPress: () {
              if (groupModel != null) {
                groupController.updateGroup();
              } else {
                groupController.createGroup();
              }
              //createGroupController.createGroup(id: id, members: members, createdBy: createdBy, createdAt: createdAt)

            }),
          ),
          SizedBox(height: 20,)

        ], appBarTitle: title);
  }
}
