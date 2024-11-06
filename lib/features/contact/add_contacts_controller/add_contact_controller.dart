import 'package:alarm_app/core/supabase/group_contacts.dart';
import 'package:alarm_app/core/supabase/notification_crud.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    String userNumber = authController.userModel.value.phone.substring(authController.userModel.value.phone.length - 10 );
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts =
          await FlutterContacts.getContacts(withProperties: true);

      phoneContacts.value = contacts
          .where((contact) => contact.phones.isNotEmpty && !contact.phones.first.number.replaceAll(RegExp(r'[^0-9]'), '').contains(userNumber))
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
  String normalizePhoneNumber(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future addedContacts(Map<String, String> contact) async {

    String phoneNumber = contact['phone']!;
    String phoneWithoutCode = normalizePhoneNumber(phoneNumber);
        phoneWithoutCode = phoneWithoutCode.substring(phoneWithoutCode.length - 10);
    final isDuplicateInApp = requestedFriends.where((friend) => friend.friendPhone!.contains(phoneWithoutCode)).toList();
    if (isDuplicateInApp.isNotEmpty) {
      Utils.showErrorSnackBar(
          title: "Already Added",
          description: "Contact already exists in the added contacts."
      );
      return;
    }

    var existingFriend = await friendsService.fetchFriendPhoneByNumber(authController.userModel.value.id, phoneWithoutCode);
    if (existingFriend != null) {
      Utils.showErrorSnackBar(
          title: "Already Added",
          description: "Contact already exists in the database."
      );
      return;
    }
    // Fetch user profile by phone number
    var userProfile = await GroupContacts.fetchUserProfileByPhone(phoneWithoutCode);
    if (userProfile == null) {
      Utils.showErrorSnackBar(
          title: "Contact Not Found",
          description: "This contact does not exist in the system."
      );
      return;
    }

    // Add the friend to Supabase
    await friendsService.addFriend(FriendsModel(
      id: const Uuid().v4(),
      friendId: userProfile['id']!,
      editedName: contact['name']!,
      userId: authController.userModel.value.id,
      requestStatus: 0,
      createdAt: DateTime.now(),
      friendPhone: phoneWithoutCode,
    ));

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

    await NotificationCrud.createNotification(
        notificationFrom: authController.userModel.value.id,
        notificationFor: userProfile['id']!,
        notificationType: 'invitation',
        data: {}, address: {}
    );
    // Add the contact to the local list of added friends

    requestedFriends.add(FriendsModel(
      id: const Uuid().v4(),
      friendId: userProfile['id']!,
      editedName: contact['name']!,
      userId: authController.userModel.value.id,
      requestStatus: 0,
      createdAt: DateTime.now(),
      friendPhone: phoneWithoutCode,
    ));
    if (kDebugMode) {
      print('Contact added to Supabase and local list.');
    }


  }







  void removeContact(int index, var friendId) async {
    await friendsService.deleteFriend(
        friendId, authController.userModel.value.id);
    requestedFriends.removeAt(index);
  }

  void updateContactName(
      {required int index,
      required String newName,
      required var friendId}) async {
    await friendsService.updateFriend(
        newName, friendId, authController.userModel.value.id);
    update();
  }


  void fetchFriends(){
    var userId=Get.find<AuthController>().userModel.value.id;
    print(userId);
    friendsService.subscribeToFriends(userId, requestedFriends);
  }

  // Future<void> fetchFriends() async {
  //   try {
  //     isLoading(true);
  //     String userId = authController.userModel.value.id;
  //     print("This is my ID   ${userId}");
  //     final response = await friendsService.fetchFriends(userId);
  //     print("These are friends of minf  ${response}");
  //     if (response.isNotEmpty) {
  //       requestedFriends.value =
  //           response;
  //     } else {
  //       if (kDebugMode) {
  //         print('No friends found');
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error: $e');
  //     }
  //   } finally {
  //     isLoading(false);
  //   }
  // }


  //REAL TIME PROGRESS O



  // // var friendsList = <FriendsModel>[].obs; // Observable list of friends
  //
  // void fetchInitialFriends() async {
  //   String userId = authController.userModel.value.id;
  //   final response = await Supabase.instance.client
  //       .from('friends')
  //       .select()
  //       .eq('user_id', userId);
  //
  //   if (response != null && response.isNotEmpty) {
  //     requestedFriends.assignAll(response.map((data) => FriendsModel.fromMap(data)).toList());
  //   }
  // }
  //
  // // Subscribe to real-time updates for friends
  // void listenToFriendUpdates() {
  //   String userId = authController.userModel.value.id;
  //   Supabase.instance.client
  //       .from('friends')
  //       .stream(primaryKey: ['id']) // Watch for changes in requestStatus
  //       .eq('user_id', userId) // Filter by your user ID
  //       .listen((event) {
  //     handleRealTimeUpdates(event);
  //   });
  // }
  //
  // // Handle real-time updates and update the UI
  // void handleRealTimeUpdates(List<Map<String, dynamic>> event) {
  //   final updatedFriends = event.map((data) => FriendsModel.fromMap(data)).toList();
  //   requestedFriends.assignAll(updatedFriends); // Update the friendsList
  //   update(); // Trigger UI update in GetX
  // }
  //
  //

  @override
  void onInit()async {
    super.onInit();
    fetchGroupContacts();
    fetchPhoneContacts();
    fetchFriends();
    // listenToFriendUpdates(); // Listen to real-time updates on initialization
    // fetchInitialFriends(); // Fetch initial data
  }
}
