import 'dart:developer';

import 'package:alarm_app/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FireStoreNotifications {
  static final _notificationCollection =
      FirebaseFirestore.instance.collection("notifications");

  static Future addNotification(NotificationModel notificationModel) async {
    await _notificationCollection
        .doc(notificationModel.id)
        .set(notificationModel.toJson());
  }

  static Future removeNotification(String notificationId) async {
    await _notificationCollection.doc(notificationId).delete();
  }

  static Future<List<dynamic>> getNotifications() async {
    List<String> notificationForList = [
      "all",
      FirebaseAuth.instance.currentUser!.uid
    ];
    final snapshot = await _notificationCollection
        .where("notificationFor", whereIn: notificationForList)
        .orderBy("timestamp", descending: true)
        .get();
    if (snapshot.size == 0) return [];
    List<dynamic> notificationList = [];
    DateTime currentTimestamp =
        (snapshot.docs.first.data()["timestamp"] as Timestamp).toDate();
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));
    if (isOnSameDay(currentTimestamp, today)) {
      notificationList.add("Today");
    }
    for (final notification in snapshot.docs) {
      final NotificationModel notificationModel =
          NotificationModel.fromJson(notification.data());
      log(notificationModel.toString());

      if (!isOnSameDay(
          currentTimestamp, notificationModel.timestamp.toDate())) {
        if (isOnSameDay(notificationModel.timestamp.toDate(), yesterday)) {
          notificationList.add("Yesterday");
          currentTimestamp = notificationModel.timestamp.toDate();
        } else {
          currentTimestamp = notificationModel.timestamp.toDate();
          notificationList
              .add(DateFormat('MMMM, dd yyyy').format(currentTimestamp));
        }
      }

      notificationList.add(notificationModel);
    }

    return notificationList;
  }
}

bool isOnSameDay(DateTime timestamp, DateTime targetDate) {
  return timestamp.year == targetDate.year &&
      timestamp.month == targetDate.month &&
      timestamp.day == targetDate.day;
}
