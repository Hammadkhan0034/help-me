import 'package:alarm_app/core/supabase/group_contacts.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../core/supabase/FriendsService.dart';
import '../../../models/friends_model.dart';
import '../../../servies/send_notification_services.dart';

class AddContactController extends GetxController {
  var groupContacts = <String>[].obs;
  var phoneContacts = <Map<String, String>>[].obs;
  var matchedContacts = <Map<String, String>>[].obs;
  var isLoading = false.obs;
  var requestedFriends = <FriendsModel>[].obs;
  AuthController authController = Get.put(AuthController());
  var isEditing = false.obs;
  GroupContacts groupServices = GroupContacts();
  TextEditingController editedName = TextEditingController();
  final friendsService = FriendsService();
  Future<void> fetchGroupContacts() async {
    isLoading(true);
    try {
      groupContacts.value = await GroupContacts.fetchGroupContacts();
      if (kDebugMode) {
        print('Group Contacts: $groupContacts');
      }
      findMatchedContacts();
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching group contacts: $error');
      }
    } finally {
      isLoading(false);
    }
  }

  void findMatchedContacts() {
    matchedContacts.value = phoneContacts.where((contact) {
      String? phoneNumber = contact['phone'];
      if (phoneNumber!.length >= 10) {
        String phoneNumberWithoutCode =
            phoneNumber.substring(phoneNumber.length - 10);
        return groupContacts.contains(phoneNumberWithoutCode);
      }
      return false;
    }).toList();
    if (kDebugMode) {
      print('Matched Contacts: $matchedContacts');
    }
  }

  Future<void> fetchPhoneContacts() async {
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);

      phoneContacts.value = contacts
          .where((contact) => contact.phones.isNotEmpty)
          .map((contact) => {
                'phone': contact.phones.first.number
                    .replaceAll(RegExp(r'[^0-9]'), ''),
                'name': contact.displayName,
              })
          .toList();
      findMatchedContacts();
    } else {
      Get.snackbar('Permission Denied',
          'Please grant contact access permission to load contacts.');
    }
  }

  void addedContacts(Map<String, String> contact) async {
    String phoneNumber = contact['phone']!;
    String phoneWithoutCode = phoneNumber.length > 10
        ? phoneNumber.substring(phoneNumber.length - 10)
        : phoneNumber;
    bool isDuplicateInApp = requestedFriends
        .any((friend) => friend.friendPhone == phoneWithoutCode);
    if (isDuplicateInApp) {
      Utils.showErrorSnackBar(
          title: "Already Added", description: "Contact already exists.");
      print('Duplicated Contacts');
      return;
    }
    var existingFriend = await friendsService.fetchFriendPhoneByNumber(
        authController.userModel.value.id, phoneWithoutCode);
    if (existingFriend != null) {
      Utils.showErrorSnackBar(
          title: "Already Added",
          description: "Contact already exists in the database.");
      return;
    }
    var userProfile =
        await GroupContacts.fetchUserProfileByPhone(phoneWithoutCode);
    await friendsService.addFriend(FriendsModel(
      id: const Uuid().v4(),
      friendId: contact['id']!,
      editedName: contact['name']!,
      userId: authController.userModel.value.id,
      requestStatus: 0,
      createdAt: DateTime.now(),
      friendPhone: phoneWithoutCode,
    ));
    final fcm = await friendsService.fetchFriendFcm(
        userProfile?['id']!, authController.userModel.value.id);
    if (fcm != null && fcm.isNotEmpty) {
      SendNotificationService.sendNotificationUsingApi(
          fcmList: [fcm.toString()],
          title: "Request Contacts: ${authController.userModel.value.name}",
          body: "${authController.userModel.value.phone}",
          data: {});
    } else {
      print("Failed to send notification: Invalid FCM token");
    }

    if (kDebugMode) {
      print('Contact added to Supabase.');
    }
    await fetchFriends(); // Fetch the updated friends list
  }

  void removeContact(int index, var friendId) async {
    await friendsService.deleteFriend(
        friendId, authController.userModel.value.id);
    requestedFriends.removeAt(index);
    await fetchFriends();
  }

  void updateContactName(
      {required int index,
      required String newName,
      required var friendId}) async {
    await friendsService.updateFriend(
        newName, friendId, authController.userModel.value.id);
    await fetchFriends();
    update();
  }

  Future<void> addFriend({
    required String friendId,
    required String userId,
    required int requestStatus,
  }) async {
    await friendsService.addFriend(FriendsModel(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      friendId: friendId,
      editedName: editedName.text,
      userId: userId,
      requestStatus: 0,
    ));
  }

  Future<void> fetchFriends() async {
    try {
      isLoading(true);
      String userId = authController.userModel.value.id;
      print("This is my ID   ${userId}");
      final response = await friendsService.fetchFriends(userId);
      print("These are friends of minf  ${response}");
      if (response.isNotEmpty) {
        requestedFriends.value =
            response;
      } else {
        if (kDebugMode) {
          print('No friends found');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit()async {
    super.onInit();
    fetchGroupContacts();
    fetchPhoneContacts();
    fetchFriends();
  }
}
