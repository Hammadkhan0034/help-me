import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationCrud{
  // Create a new notification
 static Future<void> createNotification(String notificationFrom, String notificationFor, String notificationType, Map<String, dynamic> data) async {
    final response = await Supabase.instance.client
        .from('notifications')
        .insert({
      'notification_from': notificationFrom,
      'notification_for': notificationFor,
      'notification_type': notificationType,
      'data': data,
    })
   ;

    if (response.error != null) {
      throw Exception('Error creating notification: ${response.error!.message}');
    }
  }

// Read notifications for a user
  static Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final response = await Supabase.instance.client
        .from('notifications')
        .select()
        .eq('notification_for', userId)
;

    // if (response.error != null) {
    //   throw Exception('Error fetching notifications: ${response.error!.message}');
    // }
    return List<Map<String, dynamic>>.from(response);
  }

// Delete a notification
  static Future<void> deleteNotification(String notificationId) async {
    final response = await Supabase.instance.client
        .from('notifications')
        .delete()
        .eq('id', notificationId)
      ;

    if (response.error != null) {
      throw Exception('Error deleting notification: ${response.error!.message}');
    }
  }

}