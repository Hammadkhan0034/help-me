import 'package:alarm_app/core/firebase_cloud_messaging/fcm_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/friends_model.dart';

class FriendsService {
  final SupabaseClient client = Supabase.instance.client;

  Future<void> addFriend(FriendsModel friend) async {
    try {
      final response = await client
          .from('friends')
          .upsert(friend.toMap()).select()
          ;

      if (response == null) {
        throw Exception('Response is null, no data received from Supabase.');
      }
      // Log success
      print("Friend added successfully");
    } catch (error) {
      // Catch and handle errors properly
      print("Error adding friend: $error");
      rethrow;
    }
  }

  // Read
  // Future<List<FriendsModel>> getFriends(String userId) async {
  //   final response = await client
  //       .from('friends')
  //       .select()
  //       .eq('user_id', userId);
  //
  //   return response.map((e) => FriendsModel.fromMap(e)).toList();
  // }


  Future<void> updateFriend(String name, String friendId, String userId) async {
  await client
        .from('friends')
        .update({
      'edited_name': name,
      'updated_at': DateTime.now().toIso8601String(),
    })
        .eq('friend_id', friendId)
        .eq('user_id', userId)
        .select();
    print("Updated Friend's Name");
  }


  // Delete Implemented
  Future<void> deleteFriend(String friendId, String userId) async {
   await client
        .from('friends')
        .delete()
        .eq('friend_id', friendId)
        .eq('user_id', userId)
        ;
    print("Deleted Friend");
  }
  //Implemented
  Future<String?> fetchFriendFcm(String friendRequestId, String userId) async {
    print("Fetching FCM for Friend ID: $friendRequestId and User ID: $userId");
    try {
      final friendResponse = await client
          .from('friends')
          .select('friend_id')
          .eq('friend_id', friendRequestId)
          .eq('user_id', userId)
          .maybeSingle();

      if (friendResponse == null || friendResponse['friend_id'] == null) {
        print("No friend found with the provided request ID: $friendRequestId and user ID: $userId");
        return null;
      }

      String friendId = friendResponse['friend_id'];

      final profileResponse = await client
          .from('profiles')
          .select('fcm')
          .eq('id', friendId)
          .maybeSingle();
      if (profileResponse == null || profileResponse['fcm'] == null) {
        print("No FCM token found for friendId: $friendId in profiles table.");
        return null;
      }

      String fcmToken = profileResponse['fcm'];
      print("Friend FCM token: $fcmToken");

      return fcmToken;
    } catch (error) {
      print("Error fetching FCM token: $error");
      return null;
    }
  }
//Implemented
  Future<List<FriendsModel>> fetchFriends(String userId) async {
    try {

      final response = await client
          .from('friends')
          .select('*, profiles(phone)')
          .eq('user_id', userId);
      print("These are friends of minf  ${response}");
      List<FriendsModel> friends = (response as List)
          .map((friend) {
        Map<String, dynamic> friendMap = friend as Map<String, dynamic>;
        String? phoneNumber = friendMap['profiles']?['phone'];
        return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
      })
          .toList();

      return friends;
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  Future<String?> fetchFriendPhoneByNumber(String userId, String friendPhoneNumber) async {
    try {
      final response = await client
          .from('friends')
          .select('*, profiles(phone)')
          .eq('user_id', userId)
          .ilike('profiles.phone', '%$friendPhoneNumber%'); // Use ilike for case-insensitive matching

      // Ensure that the response is properly handled
      List<FriendsModel> friends = (response as List)
          .map((friend) {
        Map<String, dynamic> friendMap = friend as Map<String, dynamic>;

        // Extract the phone number from the joined profiles table
        String? phoneNumber = friendMap['profiles']?['phone'];

        // Add the phone number to FriendsModel or handle it as needed
        return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
      })
          .toList();

      // If there are any matched friends, return the phone number of the first matched friend
      if (friends.isNotEmpty) {
        return friends.first.friendPhone;
      }

      return null; // Return null if no matches are found
    } catch (e) {
      print('Error fetching friend phone number: $e');
      return null;
    }
  }

  // Future<FriendsModel?> fetchFriendByPhone(String phone, String userId) async {
  //   try {
  //     final response = await client
  //         .from('friends')
  //         .select()
  //         .eq('phone', phone)
  //         .eq('userId', userId)
  //         .limit(1)
  //         .single();
  //     if (response != null && response.isNotEmpty) {
  //       return FriendsModel.fromMap(response); // Assuming you have a fromJson method in FriendsModel
  //     } else {
  //       return null; // No friend found
  //     }
  //   } catch (error) {
  //     print('Error fetching friend by phone: $error');
  //     return null;
  //   }
  // }

}
