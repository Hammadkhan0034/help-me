import 'dart:io';

import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/core/supabase/FriendsService.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/features/door/controllers/door_controller.dart';
import 'package:alarm_app/features/door/screens/widgets/group_name_drop_down.dart';
import 'package:alarm_app/servies/send_notification_services.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/supabase/notification_crud.dart';
import '../../../core/supabase/storage/storage.dart';
import '../../../models/group_model.dart';

class DoorScreen extends StatelessWidget {
  DoorScreen({super.key});

  final DoorController ctrl = Get.put(DoorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        // actions: const [Icon(Icons.person), SizedBox(width: 10)],
        title: Obx(() {
          return Text(
            "Send ${ctrl.selectedType.value}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          );
        }),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GradientContainer(
            mTop: 110,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: Text(
                      "Primary",
                      style: TextStyle(
                        color: AColors.white,
                        decorationColor: AColors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        color: AColors.darkGrey,
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Obx(() {
                                return DropdownButton<GroupModel>(
                                  isExpanded: true,
                                  value: ctrl.selectedGroup
                                      .value, // It will be null after type change, so the hint will be displayed
                                  hint: Text(
                                    ctrl.selectedGroup.value != null
                                        ? ctrl.selectedGroup.value!.name
                                        : "Select a Group", // This will be shown after the group is reset
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  items: ctrl.groups.map((GroupModel group) {
                                    return DropdownMenuItem<GroupModel>(
                                      value: group,
                                      child: Text(group.name),
                                    );
                                  }).toList(),
                                  onChanged: (GroupModel? selectedGroup) {
                                    ctrl.selectedGroup.value =
                                        selectedGroup; // Update the selected group
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      GroupNameDropDown(ctrl: ctrl),
                    ],
                  ),
                  const SizedBox(height: 10),


            Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
        color: AColors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          TextField(
            controller: ctrl.message,
            maxLines: 5,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "message....",
              hintStyle: TextStyle(
                color: AColors.darkGrey,
              ),
            ),
          ),
              Obx(() {
                if (ctrl.localImagePath.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      height: 150,
                      width: 150,
                      child: Image.file(
                        File(ctrl.localImagePath.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink(); // If no image is selected, show nothing
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () async {
                  File? selectedImageFile = await Utils.imagePickerBottomSheet(context);

                  // If an image is picked, upload it to Supabase
                  if (selectedImageFile != null) {
                    ctrl.imageUrl.value = selectedImageFile.path;
                    ctrl.localImagePath.value = selectedImageFile.path;
                    // Upload the image file to Supabase and get the image URL
                    String? uploadedImageUrl = await MySupabaseStorage.uploadImage(selectedImageFile);
                    if (uploadedImageUrl != null) {
                      print('Image uploaded successfully: $uploadedImageUrl');
                      // Optionally, update your controller or state with the uploaded image URL
                      ctrl.imageUrl.value = uploadedImageUrl; // assuming you have such a field
                    } else {
                      // Handle the upload failure
                      print('Failed to upload image');
                    }
                  } else {
                    // Handle the case where no image was selected
                    print('No image selected');
                  }
                },
                child: const Icon(
                  Icons.image_outlined,
                  color: AColors.dark,
                  size: 28,
                ),
              ),

              const SizedBox(width: 10),
              // const Icon(Icons.camera_alt_outlined,
              //     color: AColors.dark),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),



                  const SizedBox(height: 25),

                  Padding(

                    padding: const EdgeInsets.symmetric(horizontal: 50),

                    child: Obx(() {
                      if (ctrl.isLoading.value) {
                        return loadingIndicator(); // Show loading indicator
                      } else {
                        return ElevatedButton(
                          onPressed: () {
                            ctrl.onPress();
                          },
                          child: Text("Send Notification"),
                        );
                      }
                    })

                  )
                ],
              ),
            ),
          ),
          const WarningCircleIcon(),
        ],
      ),
    );
  }
}
Widget loadingIndicator() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Customize color
      strokeWidth: 6, // Customize thickness
    ),
  );
}
