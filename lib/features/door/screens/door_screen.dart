import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/door/controllers/door_controller.dart';
import 'package:alarm_app/features/door/screens/widgets/group_name_drop_down.dart';
import 'package:alarm_app/servies/send_notification_services.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:alarm_app/widgets/gradient_container.dart';
import 'package:alarm_app/widgets/warning_circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        actions: const [Icon(Icons.person), SizedBox(width: 10)],
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
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child:Obx(() {
                                return DropdownButton<GroupModel>(
                                  isExpanded: true,
                                  value: ctrl.selectedGroup.value, // It will be null after type change, so the hint will be displayed
                                  hint: Text(
                                    ctrl.selectedGroup.value != null
                                        ? ctrl.selectedGroup.value!.name
                                        : "Select a Group",  // This will be shown after the group is reset
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  items: ctrl.groups.map((GroupModel group) {
                                    return DropdownMenuItem<GroupModel>(
                                      value: group,
                                      child: Text(group.name),
                                    );
                                  }).toList(),
                                  onChanged: (GroupModel? selectedGroup) {
                                    ctrl.selectedGroup.value = selectedGroup; // Update the selected group
                                  },
                                );
                              }),




                              // TextField(
                              //   decoration: InputDecoration(
                              //     border: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //         width: 1,
                              //         color: AColors.white,
                              //       ),
                              //     ),
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //         width: 1,
                              //         color: AColors.white,
                              //       ),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(
                              //         width: 1,
                              //         color: AColors.white,
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
                        const TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "message....",
                            hintStyle: TextStyle(
                              color: AColors.darkGrey,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap:() async{
                                  ctrl.localImagePath.value =await Utils.imagePickerBottomSheet(context);
                                },

                                child: const Icon(Icons.image_outlined, color: AColors.dark,size: 28,)),
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
                    child: AElevatedButton(
                      title: "Send",
                      bgColor: AColors.brown,
                      onPress: () {
                        // SendNotificationService.sendNotificationUsingApi(fcmList: fcmList, title: title, body: body, data: );

                      },
                    ),
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
