class NotificationModel {
  final String id;
  final String notificationFrom;
  final String notificationFor;
  final DateTime timestamp; // Use DateTime instead of Timestamp
  final String notificationType;
  final Map<String, dynamic>? data; // Can include optional fields like image, message, etc.

  const NotificationModel({
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
      'timestamp': timestamp.toIso8601String(), // Store timestamp as ISO string
      'notification_type': notificationType,
      'data': data, // This can include address, image, and message
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      notificationFrom: map['notification_from'] as String,
      notificationFor: map['notification_for'] as String,
      timestamp: DateTime.parse(map['timestamp']), // Parse the ISO string back to DateTime
      notificationType: map['notification_type'] as String,
      data: map['data'] as Map<String, dynamic>?, // Handle optional data
    );
  }

  @override
  String toString() {
    return 'NotificationModel{id: $id, notificationFrom: $notificationFrom, notificationFor: $notificationFor, timestamp: $timestamp, notificationType: $notificationType, data: $data}';
  }

  @override
  List<Object?> get props => [id, timestamp, notificationType, data];
}
