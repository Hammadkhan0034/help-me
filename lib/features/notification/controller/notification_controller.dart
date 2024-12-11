import 'dart:async';
import 'dart:developer';

import 'package:alarm_app/core/supabase/FriendsService.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/features/auth/controller/auth_controller.dart';
import 'package:alarm_app/models/notification_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/supabase/notification_crud.dart';
import '../../../models/friends_model.dart';

class NotificationController extends GetxController {
  AuthController authController = Get.find<AuthController>();
  List<NotificationModel> notifications = [];
  final int pageSize = 5;
  int currentPage = 0;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController scrollController = ScrollController();

  Future refreshNotifications() async {
    currentPage = 0;
    await getNotifications(isRefresh: true);
  }

  Future getNotifications({bool isRefresh = false}) async {
    String userId = authController.userModel.value.id;
    if (isLoading || !hasMore) return;
    isLoading = true;

    try {
      final rawNotificationList = await Supabase.instance.client
          .from('notifications')
          .select()
          .eq('notification_for', userId)
          .order("timestamp", ascending: false)
          .range(currentPage * pageSize, (currentPage + 1) * pageSize - 1);

      hasMore = rawNotificationList.length == pageSize;
      currentPage++;

      if (isRefresh) {
        notifications.clear();
      }
      for (var friendData in rawNotificationList) {
        final notification = NotificationModel.fromMap(friendData);

        // if(notifications.firstWhereOrNull((noti) => noti.notificationFor  == notification.notificationFor &&
        // noti.notificationFrom == notification.notificationFrom && notification.notificationType ==
        // noti.notificationType && notification.notificationType == "invitation" ) != null){
        //   continue;
        // }
        //
        final String notificationFromId = friendData['notification_from'];
        final user = await fetchUserDetails(notificationFromId);
        if (user != null) {
          notification.data?['name'] = user['name'];
          notification.data?['phone'] = user['phone'];
          notifications.add(notification);
        }
      }
    } catch (e, st) {
      log('Error subscribing to notification: ', error: e, stackTrace: st);
    }
    isLoading = false;
    update();
  }

  Future getNotificationsFromNotification() async {
    String userId = authController.userModel.value.id;
    int index = 0;
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    try {
      final rawNotificationList = await Supabase.instance.client
          .from('notifications')
          .select()
          .eq('notification_for', userId)
          .order("timestamp", ascending: false)
          .range(0, pageSize);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa1");

      for (var friendData in rawNotificationList) {
        final notification = NotificationModel.fromMap(friendData);
        if(notifications.firstWhereOrNull((noti) => noti.id == notification.id) != null){
          continue;
        }
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa2");

        final String notificationFromId = friendData['notification_from'];
        final user = await fetchUserDetails(notificationFromId);
        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa3");

        if (user != null) {
          print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa4");

          notification.data?['name'] = user['name'];
          notification.data?['phone'] = user['phone'];
          notifications.insert(index, notification);
          index++;
          print("aaaaaaaaaaaaaaaaaaaaaaaaaaaa5");

        }
      }
      if(index!=0) {
        update();
      }

    } catch (e, st) {
      log('Error subscribing to notification: ', error: e, stackTrace: st);
    }
  }


  Future<Map<String, dynamic>?> fetchUserDetails(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();

      if (response.isEmpty) {
        print('Error fetching user details: ${response}');
        return null;
      }

      return response;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  // Future<void> createNotification({
  //   required String notificationFrom,
  //   required String notificationFor,
  //   required String notificationType,
  //   required Map<String, dynamic>? data,
  //   required Map<String, double> address,
  // }) async {
  //   await NotificationCrud.createNotification(
  //     notificationFrom: notificationFrom,
  //     notificationFor: notificationFor,
  //     notificationType: notificationType,
  //     data: data,
  //     address: address,
  //   );
  // }

  Future<void> deleteNotification(String notificationId) async {
    print(notificationId);
    try {
      notifications.removeWhere((n) => n.id == notificationId);
      await NotificationCrud.deleteNotification(notificationId);
    } catch (e) {
      print('Error deleting notification: $e');
    }
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
    getNotifications();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMore) {
        getNotifications();
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
