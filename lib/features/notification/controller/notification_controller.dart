import 'package:alarm_app/core/supabase/FriendsService.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/models/notification_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/supabase/notification_crud.dart';
import '../../../core/supabase/user_crud.dart';
import '../../../models/friends_model.dart';

class NotificationController extends GetxController {
  AuthController authController = Get.find<AuthController>();
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;


  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String appleUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      await launch(appleUrl);
    } else {
      throw 'Could not launch map';
    }
  }
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
            .listen((snapshot) async {
              print("Notifications SnapShot of against my ID :  $snapshot");

              if (snapshot.isEmpty) {
                print('No pending friend requests for user: $userId');
                return;
              }
              // notifications.refresh();
              // Clear the list before adding new notifications (optional)
               notifications.clear();

              for (var friendData in snapshot) {
                final notificationFromId = friendData['notification_from'];

                if (notificationFromId != null) {
                  print(
                      "Pending Notification from friend request from user ID: $notificationFromId");

                  // Fetch user details from the profiles table
                  final user = await fetchUserDetails(notificationFromId);

                  if (user != null) {
                    print(
                        "Pending friend request from: ${user['name']}, Phone: ${user['phone']}");

                    final notification = NotificationModel.fromMap(friendData);
                    notification.data?['name'] = user['name'];
                    notification.data?['phone'] = user['phone'];
                    // Check if this notification already exists before adding
                    bool alreadyExists =
                        notifications.any((n) => n.id == notification.id);
                    if (!alreadyExists) {
                      notifications.add(notification);
                    }

                    notifications.refresh();
                  }
                } else {
                  print(
                      "notification_from is null for friend data: $friendData");
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
      data: data, address: address,
    );
  }

  Future<void> deleteNotification(String notificationId) async {
    print("Delting Noptification id");
    print(notificationId);
    try {
      notifications.removeWhere(
          (n) => n.id == notificationId);
      await NotificationCrud.deleteNotification(notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
    notifications.refresh();
    update();
  }
  //
  Future<void> acceptInvitation(String friendId, userId) async {
    try {
      await NotificationCrud.acceptFriendInvitation(friendId, userId);
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
