import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:alarm_app/core/supabase/groups_crud.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/models/group_model.dart';

class CreateGroupController extends GetxController {
  final AddContactController addContactController =
  Get.find<AddContactController>();
  final TextEditingController name = TextEditingController();
  var groupType = "Indoor".obs;
  void updateOption(String option) {
    groupType.value = option;
  }
  int getMemberCount() {
    return addContactController.requestedFriends.length;
  }
  Future<void> createGroup() async {

    try {
      int memberCount = getMemberCount();
      await GroupCrud.createGroup(GroupModel(
        id: Uuid().v4(),
        name: name.text,
        contacts: addContactController.requestedFriends
            .map((contact) => contact.id ?? '')
            .toList(),
        type: groupType.value,
        createdAt: DateTime.now(),
        createdBy: addContactController.authController.userModel.value.id,
        totalMembers: memberCount,
      ));


     Utils.showSuccessSnackBar(title: "Group ${name.text} ", description: "Created Successfully");
     Get.back();
    } catch (e) {
      Utils.showErrorSnackBar(title: "ERROR", description: e.toString());
      print("ERROR: $e");

    }
  }
}
