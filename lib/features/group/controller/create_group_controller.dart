import 'package:alarm_app/core/supabase/groups_crud.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/models/group_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CreateGroupController extends GetxController {
  final AddContactController addContactController =
      Get.find<AddContactController>();
  final TextEditingController name = TextEditingController();
  var groupType = "Indoor".obs;
  void updateOption(String option) {
    groupType.value = option;
  }

  Future<void> createGroup(
  ) async {
    await GroupCrud.createGroup(GroupModel(
        id: Uuid().v4(),
        name: name.text,
        contacts: addContactController.requestedFriends.map((contact) => contact.editedName ?? '').toList(),
        type: groupType.value,
        createdAt:DateTime.now(),
        createdBy: addContactController.authController.userModel.value.id));



  }
}
