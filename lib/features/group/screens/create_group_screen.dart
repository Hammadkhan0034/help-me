import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/group/controller/create_group_controller.dart';
import 'package:alarm_app/features/group/widget/door_mode_widget.dart';
import 'package:alarm_app/widgets/circular_container.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../contact/add_contacts_controller/add_contact_controller.dart';

class CreateGroupScreen extends StatelessWidget {
  CreateGroupScreen({super.key});
  final CreateGroupController createGroupController =
      Get.put(CreateGroupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const Text(
          "Create Group",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GradientContainer(
            mTop: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    const Text(
                      "Group Name",
                      style: TextStyle(
                          color: AColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: createGroupController.name,
                      style: const TextStyle(
                        color: AColors.white,  // Set the text color to white
                      ),
                      cursorColor: AColors.white,  // Set the cursor color to white
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
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Added Contacts:",
                      style: TextStyle(
                          color: AColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: createGroupController
                            .addContactController.requestedFriends.length,
                        itemBuilder: (context, index) {
                          final contact = createGroupController
                              .addContactController.requestedFriends[index];
                          return ListTile(
                            leading:SizedBox(
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
                            ) ,
                            trailing: contact.requestStatus==1? GestureDetector(
                                onTap: () {
                                  createGroupController.addToGroupContacts(contact );
                                },
                                child: Icon(Icons.add,color: Colors.white,)): Text("Pending",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    const Text(
                      "Group Contacts:",
                      style: TextStyle(
                          color: AColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: Get.height*0.15,
                      child:Obx(() {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: createGroupController.groupContacts.length,
                          itemBuilder: (context, index) {
                            final groupContact = createGroupController.groupContacts[index];
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
                            );
                          },
                        );
                      }),

                    ),
                    const SizedBox(height: 10),
                    Stack(
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
                                  label: createGroupController.groupType.value,
                                  value: createGroupController.groupType
                                      .value, // Default value from controller
                                  onChanged: (newValue) {
                                    // Handle the dropdown selection change
                                    createGroupController.updateOption(newValue);
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
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: AElevatedButton(title: "Save", onPress: () {
                        createGroupController.createGroup();
                        //createGroupController.createGroup(id: id, members: members, createdBy: createdBy, createdAt: createdAt)
                
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
            right: 1,
            top: 10,
            left: 1,
            child: ACircularContainer(
              child: Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AColors.primary,
                  child: Text(
                    "!",
                    style: TextStyle(color: Colors.white, fontSize: 50),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
