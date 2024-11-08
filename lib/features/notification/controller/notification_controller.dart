import 'package:alarm_app/core/supabase/FriendsService.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/models/notification_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/supabase/notification_crud.dart';
import '../../../models/friends_model.dart';

class NotificationController extends GetxController {
  AuthController authController = Get.find<AuthController>();
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  void subscribeToPendingFriendNotifications(String userId) {
    if (!FriendsService.isValidUUID(userId)) {
      throw Exception('Invalid UUID format for userId: $userId');
    }
    print('UUID format for userId: $userId');
    try {
      final subscription = Supabase.instance.client
          .from('notifications')
          .stream(primaryKey: ["id"])
          .eq('notification_for', userId)
          .order("timestamp", ascending: false)
          .listen((snapshot) async {
        print("Notifications SnapShot of against my ID :  $snapshot");

        if (snapshot.isEmpty) {
          print('No pending friend requests for user: $userId');
          return;
        }

        // Clear the notifications list before refreshing
        notifications.clear();

        for (var friendData in snapshot) {
          final notificationFromId = friendData['notification_from'];

          if (notificationFromId != null) {
            print(
                "Pending Notification from friend request from user ID: $notificationFromId");

            final user = await fetchUserDetails(notificationFromId);

            if (user != null) {
              print(
                  "Pending friend request from: ${user['name']}, Phone: ${user['phone']}");

              final notification = NotificationModel.fromMap(friendData);
              notification.data?['name'] = user['name'];
              notification.data?['phone'] = user['phone'];

              bool alreadyExists =
              notifications.any((n) => n.id == notification.id);
              if (!alreadyExists) {
                notifications.add(notification);
              }
              notifications.refresh();
            }
          } else {
            print("notification_from is null for friend data: $friendData");
          }
        }
      });
    } catch (e) {
      print('Error subscribing to pending friend requests: $e');
    }
  }


  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();

      if (response == null) {
        print('Error fetching user details: ${response}');
        return null;
      }

      return response;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<void> createNotification({
    required String notificationFrom,
    required String notificationFor,
    required String notificationType,
    required Map<String, dynamic>? data,
    required Map<String, double> address,
  }) async {
    await NotificationCrud.createNotification(
      notificationFrom: notificationFrom,
      notificationFor: notificationFor,
      notificationType: notificationType,
      data: data,
      address: address,
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    print("Delting Noptification id");
    print(notificationId);
    try {
      notifications.removeWhere((n) => n.id == notificationId);
      await NotificationCrud.deleteNotification(notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
    notifications.refresh();
    update();
  }

  Future<void> acceptInvitation(String friendId, String userId) async {
    try {
      await NotificationCrud.acceptFriendInvitation(friendId, userId);
      UserModel? userModel = await UserCrud.getUserById(friendId);
      await FriendsService().addFriend(FriendsModel(
        id: const Uuid().v4(),
        friendId: friendId, //other user userid
        editedName: userModel?.name ?? "",
        userId: authController.userModel.value.id,
        requestStatus: 1,
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        friendPhone: Utils.getPhoneWithoutCode(userModel?.phone ?? ""),
      ));
    } catch (e) {
      print('Error Accepting  Invitation: $e');
    }
  }

  Future<void> rejectInvitation(String friendId, userId) async {
    try {
      await NotificationCrud.rejectFriendInvitation(friendId, userId);
    } catch (e) {
      print('Error Accepting  Invitation: $e');
    }
  }

  @override
  void onInit() {
    subscribeToPendingFriendNotifications(authController.userModel.value.id);
    super.onInit();
  }
}
