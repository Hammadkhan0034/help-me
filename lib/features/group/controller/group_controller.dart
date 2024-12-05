import 'package:alarm_app/core/supabase/groups_crud.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:alarm_app/models/friends_model.dart';
import 'package:alarm_app/models/group_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class GroupController extends GetxController {
  GroupModel? selectedModel,primaryIndoor,primaryOutdoor;
  final addContactController = Get.put(ContactController());
  final authController = Get.find<AuthController>();
  var groupContacts = <FriendsModel>[].obs;
  final TextEditingController name = TextEditingController();
  final TextEditingController defaultAddress = TextEditingController();

  var groupType = "Indoor".obs;
  Position? position;

  List<GroupModel> allGroups = <GroupModel>[];


  List<GroupModel> get indoorGroups => allGroups.where((val) => val.type == "Indoor").toList();
  List<GroupModel> get outdoorGroups => allGroups.where((val) => val.type == "Outdoor").toList();

  setSelectedGroup(GroupModel groupModel) {
    selectedModel = groupModel;
    name.text = groupModel.name;
    groupType.value = groupModel.type;
    groupContacts
        .addAll(addContactController.getFriendsFromIds(groupModel.members));
    if(groupModel.type == "Indoor") {
      defaultAddress.text = groupModel.defaultAddress!;
    }
    groupContacts.refresh();
  }

  GroupModel? checkIfGroupISDeleted(GroupModel? model){
    if(model!=null) {
      if(allGroups.firstWhereOrNull((val) => val.id == model.id ) == null){
        return null;
      }
      return model;
    }
    return null;
  }

  resetCreateData() {
    selectedModel = null;
    name.text = "";
    defaultAddress.text = "";
    position = null;
    groupContacts.clear();
    groupType.value = "Indoor";
  }

  void addToGroupContacts(FriendsModel contact) {
    if (!groupContacts.contains(contact)) {
      groupContacts.add(contact);
    }
  }

  void removeContactFromGroup(String id) {
    groupContacts.removeWhere((val) => id == val.id);
  }

  void updateOption(String option) {
    groupType.value = option;
    if(option == "Indoor"){

    }else{

    }
  }

  int getMemberCount() {
    return groupContacts.length;
  }

  Future<void> loadGroups() async {
    final fetchedGroups =
        await GroupCrud.getAllGroups(authController.userModel.value.id);
    allGroups.assignAll(fetchedGroups);
    setPrimaryGroups();
    update();
  }

  Future<bool> isValidData() async{
    if (name.text.isEmpty) {
      Utils.showErrorSnackBar(
        title: "Missing Information",
        description: "Please enter a name for the group.",
      );
      return false;
    }
    if (groupType.value == "Indoor" && defaultAddress.text.isEmpty) {
      Utils.showErrorSnackBar(
        title: "Missing Information",
        description: "Please enter indoor address.",
      );
      return false;
    }

    if (getMemberCount() == 0) {
      Utils.showErrorSnackBar(
        title: "Missing Information",
        description: "Please add contacts to the group.",
      );
      return false;
    }
    if(groupType.value == "Indoor"){
      position = await Utils.getCurrentLatLng();
      if(position == null) return false;
    }
    return true;
  }

  Future<void> createGroup() async {
   if(!(await isValidData())) return;

    try {
      print(
          "MY FRIENDS ID ${groupContacts.map((members) => members.friendId)}");
      int memberCount = getMemberCount();
      GroupModel groupModel =           GroupModel(
        id: const Uuid().v4(),
        name: name.text,

        members:
        groupContacts.map((members) => members.friendId).toList(),
        type: groupType.value,
        createdAt: DateTime.now(),
        createdBy: addContactController.authController.userModel.value.id,
        totalMembers: memberCount,

      );
      if(groupType.value == "Indoor"){
        groupModel = groupModel.copyWith(defaultAddress: defaultAddress.text.trim(),defaultLatitude: position!.latitude,defaultLongitude: position!.longitude);
      }
      await GroupCrud.createGroup(
groupModel      );
      loadGroups();
      Get.back();
      Utils.showSuccessSnackBar(
        title: "Group ${name.text}",
        description: "Created Successfully",
      );
    } catch (e) {
      Utils.showErrorSnackBar(
        title: "ERROR: ",
        description: e.toString(),
      );
      print("ERROR: $e");
    }
  }


  Future<void> updateGroup() async {
    if(!(await isValidData())) return;

    try {
      print(
          "MY FRIENDS ID ${groupContacts.map((members) => members.friendId)}");
      selectedModel = selectedModel!.copyWith(name: name.text,members: groupContacts.map((members) => members.friendId ).toList(),type: groupType.value, totalMembers: groupContacts.length, );
      if(groupType.value == "Indoor"){
        selectedModel = selectedModel?.copyWith(defaultAddress: defaultAddress.text.trim(),defaultLatitude: position!.latitude,defaultLongitude: position!.longitude);
      }
      final status = await GroupCrud.updateGroup(selectedModel!);
      if(status){
        loadGroups();
        Get.back();
        Utils.showSuccessSnackBar(
          title: "Group ${name.text}",
          description: "Group updated successfully",
        );
      }else{
        Utils.showErrorSnackBar(
          title: "Group ${name.text}",
          description: "Error couldn't update group.",
        );
      }

    } catch (e) {
      Utils.showErrorSnackBar(
        title: "ERROR: ",
        description: e.toString(),
      );
      print("ERROR: $e");
    }
  }
  removeGroupFromPrimaryIfExists(GroupModel group){

    if(group.id == authController.userModel.value.primaryIndoor){
      authController.updatePrimaryIndoorGroup(null);
      primaryIndoor = null;
    }
    if(group.id == authController.userModel.value.primaryOutdoor){
      authController.updatePrimaryOutdoorGroup(null);
      primaryOutdoor = null;
    }
  }

  deleteGroup(GroupModel groupModel, int index) async {
    final isDeleted = await GroupCrud.deleteGroup(groupModel.id!);
    if (isDeleted) {
      allGroups.removeAt(index);
      removeGroupFromPrimaryIfExists(groupModel);


      Utils.showSuccessSnackBar(
          title: "Delete Group",
          description: "Group ${groupModel.name} deleted successfully");
      update();
    } else {
      Utils.showErrorSnackBar(
          title: "Delete Group",
          description: "Couldn't delete Group ${groupModel.name}.");
    }
  }
  setPrimaryGroups(){
    if(authController.userModel.value.primaryIndoor!= null){
      primaryIndoor = allGroups.firstWhereOrNull((val) => val.id == authController.userModel.value.primaryIndoor);
    }
    if(authController.userModel.value.primaryOutdoor!= null){
      primaryOutdoor = allGroups.firstWhereOrNull((val) => val.id == authController.userModel.value.primaryOutdoor);
    }

  }

  @override
  void onInit() {
    loadGroups();
    // TODO: implement onInit
    super.onInit();
  }
}
