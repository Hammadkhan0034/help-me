import 'package:alarm_app/core/supabase/groups_crud.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/models/friends_model.dart';
import 'package:alarm_app/models/group_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateGroupController extends GetxController {
  final addContactController = Get.put(ContactController());
  final authController = Get.find<AuthController>();
  var groupContacts = <FriendsModel>[].obs;
  final TextEditingController name = TextEditingController();
  var groupType = "Indoor".obs;
  void addToGroupContacts(FriendsModel contact) {
    if (!groupContacts.contains(contact)) {
      groupContacts.add(contact);
    }
  }

  void updateOption(String option) {
    groupType.value = option;
  }

  int getMemberCount() {
    return groupContacts.length;
  }

  Future<void> createGroup() async {
    if (name.text.isEmpty) {
      Utils.showErrorSnackBar(
        title: "Missing Information",
        description: "Please enter a name for the group.",
      );
      return;
    }

    if (getMemberCount() == 0) {
      Utils.showErrorSnackBar(
        title: "Missing Information",
        description: "Please add contacts to the group.",
      );
      return;
    }
    try {
      print(
          "MY FRIENDS ID ${groupContacts.map((members) => members.friendId)}");
      int memberCount = getMemberCount();
      await GroupCrud.createGroup(GroupModel(
        id: const Uuid().v4(),
        name: name.text,
        members:
            groupContacts.map((members) => members.friendId ?? '').toList(),
        type: groupType.value,
        createdAt: DateTime.now(),
        createdBy: addContactController.authController.userModel.value.id,
        totalMembers: memberCount,
      ));

      Utils.showSuccessSnackBar(
        title: "Group ${name.text}",
        description: "Created Successfully",
      );
      name.clear();
    } catch (e) {
      Utils.showErrorSnackBar(
        title: "ERROR: ",
        description: e.toString(),
      );
      print("ERROR: $e");
    }
  }
}
