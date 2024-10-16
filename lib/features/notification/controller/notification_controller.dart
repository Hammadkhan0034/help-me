import 'package:alarm_app/core/supabase/FriendsService.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/models/notification_model.dart';
import 'package:get/get.dart';

import '../../../core/supabase/notification_crud.dart';
import '../../../core/supabase/user_crud.dart';
import '../../../models/friends_model.dart';

class NotificationController extends GetxController {
  AuthController authController=Get.find<AuthController>();
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  FriendsService friendsService=FriendsService();

  //THIS ONE IS WORKING BUT HAS LITTLE ISSUE
  // Future<void> fetchNotifications(String userId) async {
  //   try {
  //     // Step 1: Fetch the friends with request_status 0
  //     List<FriendsModel> friends = await friendsService.fetchFriends(userId);
  //     List<String> friendIds = friends
  //         .where((friend) => friend.requestStatus == 0) // Filter by request_status
  //         .map((friend) => friend.friendId)
  //         .toList();
  //
  //     print("PRINTING FRIENDS");
  //     for (var friend in friends) {
  //       print("Friend ID: ${friend.friendId}, Request Status: ${friend.requestStatus}");
  //     }
  //     print("Friend IDs: $friendIds");
  //
  //     // Step 2: Fetch notifications for the current user
  //     final notificationData = await NotificationCrud.getNotifications(userId);
  //     print("PRINTING NOTIFICATION DATA");
  //     print(notificationData);
  //
  //     notifications.clear();
  //
  //     for (var notifData in notificationData) {
  //       final notification = NotificationModel.fromMap(notifData);
  //       print("PRINTING NOTIFICATION");
  //       print(notification);
  //
  //       // Print notification details for debugging
  //       print("Notification From ID: ${notification.notificationFrom}");
  //
  //       // Step 3: Check if notification is from a friend with request_status 0
  //       if (friendIds.contains(notification.notificationFrom)) {
  //         print("PRINTING user");
  //
  //         // Fetch user details
  //         final user = await UserCrud.getUser(notification.notificationFrom);
  //         if (user != null) {
  //           print("PRINTING USER DETAILS WHO SENT NOTIFICATION");
  //           // Update notification with user info
  //           notification.data?['name'] = user['name'];
  //           notification.data?['phone'] = user['phone'];
  //         }
  //         // Add the updated notification to the list
  //         notifications.add(notification);
  //       } else {
  //         print("No match found for notification sender in friend IDs.");
  //       }
  //     }
  //
  //     notifications.refresh();
  //   } catch (e) {
  //     print('Error fetching notifications: $e');
  //   }
  //   update();
  // }

  Future<void> fetchNotifications(String userId) async {
    try {
      // Step 1: Fetch friends for the current user, filtering by request_status 0
      List<FriendsModel> friends = []; //await friendsService.fetchFriends(userId);
      List<String> friendIds = friends
          .where((friend) => friend.requestStatus == 0) // Filter by request_status
          .map((friend) => friend.friendId) // Ensure this is fetching the correct ID
          .toList();

      print("PRINTING FRIENDS");
      for (var friend in friends) {
        print("Friend ID: ${friend.friendId}, User ID: ${friend.userId}, Request Status: ${friend.requestStatus}");
      }
      print("Friend IDs: $friendIds");

      // Step 2: Fetch notifications for the current user
      final notificationData = await NotificationCrud.getNotifications(userId);
      print("PRINTING NOTIFICATION DATA");
      print(notificationData);

      notifications.clear();

      for (var notifData in notificationData) {
        final notification = NotificationModel.fromMap(notifData);
        print("PRINTING NOTIFICATION");
        print(notification);

        // Print notification details for debugging
        print("Notification From ID: ${notification.notificationFrom}");

        // Step 3: Check if notification is from a friend with request_status 0
        if (friendIds.contains(notification.notificationFrom)) {
          print("Found matching friend for notification sender");

          // Fetch user details
          final user = await UserCrud.getUser(notification.notificationFrom);
          if (user != null) {
            print("PRINTING USER DETAILS WHO SENT NOTIFICATION");
            // Update notification with user info
            notification.data?['name'] = user['name'];
            notification.data?['phone'] = user['phone'];
          }
          // Add the updated notification to the list
          notifications.add(notification);
        } else {
          print("No match found for notification sender in friend IDs: ${notification.notificationFrom}");
        }
      }

      notifications.refresh();
    } catch (e) {
      print('Error fetching notifications: $e');
    }
    update();
  }


  Future<void> createNotification({
    required String notificationFrom,
    required String notificationFor,
    required String notificationType,
    required Map<String, dynamic>? data,
  }) async {
    await NotificationCrud.createNotification(
      notificationFrom: notificationFrom,
      notificationFor: notificationFor,
      notificationType: notificationType,
      data: data,
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
    //  notifications.removeWhere((n) => n.id == notificationId); // Remove from local list as well
      await NotificationCrud.deleteNotification(notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
    notifications.refresh()
;    update();
  }
  //
  Future<void> acceptInvitation(String friendId, userId)async{
    try {
      await NotificationCrud.acceptFriendInvitation(friendId, userId);
    } catch (e) {
      print('Error Accepting  Invitation: $e');
    }
  }
  Future<void> rejectInvitation(String friendId, userId)async{
    try {
      await NotificationCrud.rejectFriendInvitation(friendId, userId);

    } catch (e) {
      print('Error Accepting  Invitation: $e');
    }
  }

  @override
  void onInit() {
    fetchNotifications(authController.userModel.value.id);
    super.onInit();
  }
}
