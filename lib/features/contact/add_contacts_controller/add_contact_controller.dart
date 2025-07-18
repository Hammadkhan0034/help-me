import 'dart:async';
import 'dart:developer';

import 'package:alarm_app/core/supabase/group_contacts.dart';
import 'package:alarm_app/core/supabase/notification_crud.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/features/tutorial_controller.dart';
import 'package:alarm_app/models/phone_number_model.dart';
import 'package:alarm_app/utils/MyEnums.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/supabase/FriendsService.dart';
import '../../../models/friends_model.dart';
import '../../../servies/send_notification_services.dart';
import '../../../utils/shared_prefs.dart';

class ContactController extends GetxController {
  var groupContacts = <String>[].obs;
  var phoneContacts = <PhoneNumberModel>[].obs;
  var matchedContacts = <PhoneNumberModel>[].obs;
  var isLoading = false.obs;
  var requestedFriends = <FriendsModel>[].obs;
  AuthController authController = Get.find<AuthController>();
  var isEditing = false.obs;
  GroupContacts groupServices = GroupContacts();
  TextEditingController editedName = TextEditingController();
  final friendsService = FriendsService();
  late StreamSubscription friendStream;

  List<FriendsModel> getFriendsFromIds(List<String> ids) {
    return requestedFriends.where((val) => ids.contains(val.friendId)).toList();
  }

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
      String phoneNumber = contact.phone;
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
    if (MySharedPrefs()
            .getBool(TutorialController.isHomeTutorialFinishedOnce) ==
        false) {
      return;
    }

    await Future.delayed(Duration(milliseconds: 500));

    String userNumber = authController.userModel.value.phone!
        .substring(authController.userModel.value.phone!.length - 10);
    bool isPermissionGranted = await Permission.contacts.isGranted;
    if (!isPermissionGranted) {
      bool isOk = await Utils.askForPermissionConfirmation(Get.context!,
          title: "Contacts Permission",
          description:
              "Help Me requires contact permission to add your family and friends.Your contacts will not be stored or shared with anyone. Are you sure you want to allow it?",
          icon: Icons.notifications);
      if (!isOk) return;
    }
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);

      phoneContacts.value = contacts
          .where((contact) =>
              contact.phones.isNotEmpty &&
              !contact.phones.first.number
                  .replaceAll(RegExp(r'[^0-9]'), '')
                  .contains(userNumber))
          .map((contact) => PhoneNumberModel(
                phone: contact.phones.first.number
                    .replaceAll(RegExp(r'[^0-9]'), ''),
                name: contact.displayName,
              ))
          .toList()
          .toSet()
          .toList();
      print(phoneContacts);
      findMatchedContacts();
    } else {
      Get.snackbar('Permission Denied',
          'Please grant contact access permission to load contacts.');
    }
  }

  String normalizePhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future sendFriendRequestToUser(PhoneNumberModel contact) async {
    String phoneNumber = contact.phone;
    String phoneWithoutCode = normalizePhoneNumber(phoneNumber);
    phoneWithoutCode = phoneWithoutCode.substring(phoneWithoutCode.length - 10);
    final isDuplicateInApp = requestedFriends
        .where((friend) => friend.friendPhone!.contains(phoneWithoutCode))
        .toList();
    if (isDuplicateInApp.isNotEmpty) {
      Utils.showErrorSnackBar(
          title: "Already Added",
          description: "Contact already exists in the added contacts.");
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
    // Fetch user profile by phone number
    var userProfile =
        await GroupContacts.fetchUserProfileByPhone(phoneWithoutCode);
    if (userProfile == null) {
      Utils.showErrorSnackBar(
          title: "Contact Not Found",
          description: "This contact does not exist in the system.");
      return;
    }

    // Add the friend to Supabase
    await friendsService.addFriend(FriendsModel(
      id: const Uuid().v4(),
      friendId: userProfile['id']!,
      editedName: contact.name,
      userId: authController.userModel.value.id,
      requestStatus: 0,
      createdAt: DateTime.now(),
      friendPhone: phoneWithoutCode,
    ));

    // requestedFriends.add(FriendsModel(
    //   id: const Uuid().v4(),
    //   friendId: userProfile['id']!,
    //   editedName: contact.name,
    //   userId: authController.userModel.value.id,
    //   requestStatus: 0,
    //   createdAt: DateTime.now(),
    //   friendPhone: phoneWithoutCode,
    // ));
    // Send notification to the friend if FCM is available
    // final fcm = await friendsService.fetchFriendFcm(userProfile['id']!, authController.userModel.value.id);
    // if (fcm != null && fcm.isNotEmpty) {
    //   // SendNotificationService.sendNotificationUsingApi(
    //   //     fcmList: [fcm.toString()],
    //   //     title: "Request Contacts: ${authController.userModel.value.name}",
    //   //     body: "${authController.userModel.value.phone}",
    //   //     data: {}
    //   // );
    //
    // }
    //
    // else {
    //   print("Failed to send notification: Invalid FCM token");
    // }

    await SendNotificationService.sendNotificationUsingApi(
        fcmList: [userProfile['fcm']!],
        title: "Friend Request",
        body:
            "You got a friend request from ${authController.userModel.value.name}",
        data: null,
        notificationType: NotificationTypes.normal);

    // Check if user exists in profiles before creating notification
    final profile = await Supabase.instance.client
        .from('profiles')
        .select('id')
        .eq('id', userProfile['id']!)
        .maybeSingle();

    if (profile != null) {
      await NotificationCrud.createNotification(
          notificationFrom: authController.userModel.value.id,
          notificationFor: userProfile['id']!,
          notificationType: 'invitation',
          data: {},
          address: {});
    } else {
      print('User does not exist, skipping notification.');
    }
    // Add the contact to the local list of added friends

    if (kDebugMode) {
      print('Contact added to Supabase and local list.');
    }
  }

  void removeContact(int index, var friendId) async {
    // requestedFriends.removeAt(index);
    await friendsService.deleteFriend(
        friendId, authController.userModel.value.id);
  }

  void updateContactName(
      {required int index,
      required String newName,
      required var friendId}) async {
    try {
      await friendsService.updateFriend(
          newName, friendId, authController.userModel.value.id);
      requestedFriends[index] =
          requestedFriends[index].copyWith(editedName: newName);
      Get.back();
      // update();
    } catch (e, st) {
      log("Update user contact name", error: e, stackTrace: st);
    }
  }

  void subscribeToFriends() {
    var userId = Get.find<AuthController>().userModel.value.id;
    friendStream =
        friendsService.subscribeToFriends(userId).listen((snapshot) async {
      print("aaaaaaagsgkhfdkhfdskjhfkjhfdkhfgkhghfgdkhfgdkhgdfkjhfgkhdfgkjgfd");
      if (snapshot.isEmpty) {
        requestedFriends.clear(); // Clear list if no friends found
      }
      List<dynamic> friendsData = snapshot;

      List<Future<FriendsModel>> friendFutures =
          friendsData.map((friend) async {
        Map<String, dynamic> friendMap = friend as Map<String, dynamic>;

        final profileResponse = await Supabase.instance.client
            .from('profiles')
            .select('phone')
            .eq('id', friendMap['friend_id'])
            .single();

        String? phoneNumber = profileResponse['phone'] as String?;

        return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
      }).toList();

      List<FriendsModel> friends = await Future.wait(friendFutures);
      requestedFriends.clear();
      requestedFriends.addAll(friends);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    fetchGroupContacts();
    fetchPhoneContacts();
    subscribeToFriends();
    // listenToFriendUpdates(); // Listen to real-time updates on initialization
    // fetchInitialFriends(); // Fetch initial data
  }

  @override
  void dispose() {
    // TODO: implement dispose
    friendStream.cancel();
    super.dispose();
  }
}
