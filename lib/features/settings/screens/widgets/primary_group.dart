import 'package:alarm_app/constants/colors.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/group/controller/group_controller.dart';
import 'package:alarm_app/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/group_model.dart';

class PrimaryGroup extends StatefulWidget {
  const PrimaryGroup({
    super.key,
    required this.title,
    required this.groups,
    this.selectedGroup, required this.onChange,
  });
  final List<GroupModel> groups;
  final GroupModel? selectedGroup;
  final Function(GroupModel) onChange;


  final String title;

  @override
  State<PrimaryGroup> createState() => _PrimaryGroupState();
}

class _PrimaryGroupState extends State<PrimaryGroup> {
  GroupModel? selectedGroup;
  @override
  void initState() {
    // TODO: implement initState
    selectedGroup = widget.selectedGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedGroup = Get.find<GroupController>().checkIfGroupISDeleted(selectedGroup);
    return SizedBox(height: 120,
      child:
      Stack(
        children: [
          Positioned(
            height: 100,
            top: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AColors.darkGrey,
              ),
              height: 100,
              width: Get.width -20,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(

                children: [
                  SizedBox(height: 30,),
                  Expanded(
                    child:       widget.groups.isEmpty ? Center(
                      child: Text("No Group Added",                          style: const TextStyle(fontSize: 16,color: Colors.white),
                      ),
                    ) : SizedBox(
                      height: 20,
                      child: DropdownButton<GroupModel>(
                        borderRadius: BorderRadius.circular(16),
                        iconEnabledColor: Colors.white,
                        isExpanded: true,
                        value: selectedGroup,
                        hint: Text(
                          selectedGroup != null ? selectedGroup!.name : "Select a Group",
                          style: const TextStyle(fontSize: 16,color: Colors.white),
                        ),
                        items: widget.groups.map((GroupModel group) {
                          return DropdownMenuItem<GroupModel>(
                            value: group,
                            child: Text(
                              group.name,
                            ),
                          );
                        }).toList(),
                        onChanged: (GroupModel? val) {
                          widget.onChange(val!);
                          setState(() {
                            selectedGroup = val;

                          });
                        },
                        style: TextStyle(fontSize:16,color: Colors.white),
                        dropdownColor: AColors.darkGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          AElevatedButton(title: widget.title, onPress: (){}).marginSymmetric(horizontal: 20)
          // Container(
          //   width: Get.width,
          //   height: 40,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(color: AColors.dark,borderRadius: BorderRadius.circular(10) ),
          //   child: Text(widget.title,
          //     style: const TextStyle(fontSize: 20,color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }
}
