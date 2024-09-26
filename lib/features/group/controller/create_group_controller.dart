import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CreateGroupController extends GetxController {

  final TextEditingController name=TextEditingController();
  var groupType = "Indoor".obs;
  void updateOption(String option) {
    groupType.value = option;
  }

  final AddContactController addContactController =
      Get.find<AddContactController>();

  void createGroup() {


  }
}
