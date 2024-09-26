import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id, notificationFrom;
  final Timestamp timestamp;
  final String address, message;
  final Map<String, dynamic>? data;

  NotificationModel(
      {required this.id,
      required this.notificationFrom,
      required this.timestamp,
      required this.address,
      required this.message,
      required this.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      notificationFrom: json["notificationFrom"],
      timestamp:  json['timestamp'] as Timestamp,
      address: json["address"],
      message: json["message"],
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "notificationFrom": notificationFrom,
      "timestamp": timestamp,
      "address": address,
      "message": message,
      "data": data,
    };
  }

  @override
  String toString() {
    return 'NotificationModel{id: $id, notificationFrom: $notificationFrom, timestamp: $timestamp, address: $address, message: $message, data: $data}';
  }

//
}
