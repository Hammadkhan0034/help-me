import 'package:geolocator/geolocator.dart';

class NotificationModel {
  final String id;
  final String notificationFrom;
  final String notificationFor;
  final DateTime timestamp;
  final String notificationType;
  final Map<String, double>? address;
  final Map<String, dynamic>? data;

  const NotificationModel( {
    this.address,
    required this.id,
    required this.notificationFrom,
    required this.notificationFor,
    required this.timestamp,
    required this.notificationType,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notification_from': notificationFrom,
      'notification_for': notificationFor,
      'timestamp': timestamp.toIso8601String(),
      'notification_type': notificationType,
      'data': data,
      'address': {
        'latitude': address?['latitude'],
        'longitude': address?['longitude'],
      },
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      notificationFrom: map['notification_from'] as String,
      notificationFor: map['notification_for'] as String,
      timestamp: DateTime.parse(map['timestamp']), // Parse the ISO string back to DateTime
      notificationType: map['notification_type'] as String,
      data: map['data'] as Map<String, dynamic>?,
      address: map['address'] != null
          ? {
        'latitude': double.tryParse(map['address']['latitude'].toString()) ?? 0.0,
        'longitude': double.tryParse(map['address']['longitude'].toString()) ?? 0.0,
      }
          : null, // Handle the case when 'address' is null
      // Handle optional data
    );
  }

  @override
  String toString() {
    return 'NotificationModel{id: $id, notificationFrom: $notificationFrom, notificationFor: $notificationFor, timestamp: $timestamp, notificationType: $notificationType, data: $data}';
  }

  @override
  List<Object?> get props => [id, timestamp, notificationType, data];
}
