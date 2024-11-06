import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
class NotificationCrud{
//IMPLEMENTED
  static Future<void> createNotification({
    required String notificationFrom,
    required String notificationFor,
    required String notificationType,
    required Map<String, double> address,
    // required double latitude,
    // required  double longitude,
    required Map<String, dynamic>? data,
  }) async
  {
    try {
      print("Creating Notifications");

      // Insert notification into the Supabase database
      final response = await Supabase.instance.client
          .from('notifications')
          .insert({
        'id': const Uuid().v4(), // Generate a UUID
        'notification_from': notificationFrom,
        'notification_for': notificationFor,
        'notification_type': notificationType,
         'address': address ?? {},
         //{'latitude': latitude, 'longitude': longitude},
        'data': data ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      }).select();
      if (response == null) {
        print("Error creating notification: ");
        throw Exception('Error creating notification:');
      }
      // Notify user of success
      // Utils.showSuccessSnackBar(
      //     title: "Request Sent",
      //     description: "Request sent successfully."
      // );
      // Optionally, print the data returned from the database
      print("Notification created successfully: ${response.length}");

    } catch (e) {
      print('Error in createNotification: $e');
      rethrow; // Re-throw the error after logging it
    }
  }

// Read notifications for a user
  static Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    final response = await Supabase.instance.client
        .from('notifications')
        .select()
        .eq('notification_for', userId)
;
print("NOTIFICATION RESPOINSE  ");
    print(response);

    if (response == null) {
      throw Exception('Error fetching notifications: ');
    }
    return List<Map<String, dynamic>>.from(response);
  }

// Delete a notification
  static Future<void> deleteNotification(String notificationId) async {
     await Supabase.instance.client
        .from('notifications')
        .delete()
        .eq('id', notificationId)
      ;
     print("DELETD");

  }

  static Future<void> acceptFriendInvitation(String friendId, String userId) async {
    print("Friend ID is here for accepting: $friendId");
    print("My ID is here to accept: $userId");
    try {
      print('Checking record with friend_id: $userId and user_id: $friendId');
    final response=  await Supabase.instance.client
          .from('friends')
          .update({
        'request_status': 1,
        'updated_at': DateTime.now().toIso8601String(),
        'accepted_at': DateTime.now().toIso8601String(),
      })
          .eq('friend_id', userId,)
          .eq('user_id', friendId);

      // Check response
      print('Invitation accepted successfully $response');
      print(response);
    } catch (e) {
      print('Exception occurred while accepting invitation: $e');
    }
  }

  static Future<void> rejectFriendInvitation( String friendId, String userId) async {
     await Supabase.instance.client
        .from('friends')
         .delete()
         .eq('friend_id',userId )
         .eq('user_id', friendId)
       ;
  }

 // static Future<List<FriendsModel>> fetchFriends(String userId) async {
 //    try {
 //      // Step 1: Fetch the friends list
 //      final friendsResponse = Supabase.instance.client
 //          .from('friends')
 //          .select('*')
 //          .eq('user_id', userId);
 //
 //      // Step 2: For each friend, fetch the profile asynchronously
 //      List<Future<FriendsModel>> friendFutures = (friendsResponse as List)
 //          .map((friend) async {
 //        Map<String, dynamic> friendMap = friend as Map<String, dynamic>;
 //
 //        // Fetch the friend's profile using friend_id
 //        final profileResponse = Supabase.instance.client
 //            .from('profiles')
 //            .select('phone')
 //            .eq('id', friendMap['friend_id']) // Assuming 'id' is the primary key in 'profiles'
 //            .single();
 //
 //        String? phoneNumber = profileResponse['phone'];
 //
 //        // Create a FriendsModel and set the phone number
 //        return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
 //      }).toList();
 //
 //      // Step 3: Wait for all futures to complete and resolve to List<FriendsModel>
 //      List<FriendsModel> friends = await Future.wait(friendFutures);
 //
 //      return friends;
 //    } catch (e) {
 //      print('Error fetching friends: $e');
 //      return [];
 //    }
 //  }

}