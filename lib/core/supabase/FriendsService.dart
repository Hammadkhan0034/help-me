import 'package:alarm_app/features/contact/add_contacts_controller/add_contact_controller.dart';
import 'package:get/get.dart';
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


static  bool isValidUUID(String uuid) {
    final regex = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    return regex.hasMatch(uuid);
  }

  // Future<List<FriendsModel>> fetchFriends(String userId) async {
  //   if (!isValidUUID(userId)) {
  //     throw Exception('Invalid UUID format for userId: $userId');
  //   }
  //   try {
  //     final response = await client
  //         .from('friends')
  //         .select('*')
  //         .eq('user_id', userId); // Query using valid UUID
  //
  //     if (response == null) {
  //       throw Exception('Error fetching friends.');
  //     }
  //
  //     List<dynamic> friendsData = response ?? [];
  //
  //     List<Future<FriendsModel>> friendFutures = friendsData.map((friend) async {
  //       Map<String, dynamic> friendMap = friend as Map<String, dynamic>;
  //
  //       final profileResponse = await client
  //           .from('profiles')
  //           .select('phone')
  //           .eq('id', friendMap['friend_id'])
  //           .single();
  //
  //       String? phoneNumber = profileResponse['phone'] as String?;
  //
  //       return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
  //     }).toList();
  //
  //     List<FriendsModel> friends = await Future.wait(friendFutures);
  //     return friends;
  //   } catch (e) {
  //     print('Error fetching friends: $e');
  //     return [];
  //   }
  // }

  void subscribeToFriends(String userId, RxList<FriendsModel> requestedFriends) {
    if (!isValidUUID(userId)) {
      throw Exception('Invalid UUID format for userId: $userId');
    }

    try {
      // Subscribe to real-time changes in the 'friends' table for the given user_id
      final subscription = client
          .from('friends')
          .stream(primaryKey: ["id"])
          .eq('user_id', userId) // Filter by user_id
          .listen((snapshot) async {
        if (snapshot.isEmpty) {
          print('No friends found for user: $userId');
          requestedFriends.clear(); // Clear list if no friends found
          return;
        }

        // Handle the updated friend data
        List<dynamic> friendsData = snapshot;

        List<Future<FriendsModel>> friendFutures = friendsData.map((friend) async {
          Map<String, dynamic> friendMap = friend as Map<String, dynamic>;

          final profileResponse = await client
              .from('profiles')
              .select('phone')
              .eq('id', friendMap['friend_id'])
              .single();

          String? phoneNumber = profileResponse['phone'] as String?;

          return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
        }).toList();

        List<FriendsModel> friends = await Future.wait(friendFutures);

        // Update the requestedFriends list
        requestedFriends.value = friends;
      });

    } catch (e) {
      print('Error subscribing to friends: $e');
    }
  }





  // Future<String?> fetchFriendPhoneByNumber(String userId, String friendPhoneNumber) async {
  //   try {
  //     final response = await client
  //         .from('friends')
  //         .select('*, profiles!friends_friend_id_fkey(*)')
  //         .eq('user_id', userId)
  //         .ilike('profiles.phone', '%$friendPhoneNumber%');
  //
  //
  //     // Ensure that the response is properly handled
  //     List<FriendsModel> friends = (response as List)
  //         .map((friend) {
  //       Map<String, dynamic> friendMap = friend as Map<String, dynamic>;
  //       String? phoneNumber = friendMap['profiles']?['phone'];
  //       return FriendsModel.fromMap(friendMap)..friendPhone = phoneNumber;
  //     })
  //         .toList();
  //     if (friends.isNotEmpty) {
  //       return friends.first.friendPhone;
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error fetching friend phone number: $e');
  //     return null;
  //   }
  // }

  Future<List<String>?> fetchFriendPhoneByNumber(String userId, String friendPhoneNumber) async {
    try {
      final response = await client
          .from('friends')
          .select('*, profiles!friends_friend_id_fkey(*)')
          .eq('user_id', userId)
          .ilike('profiles.phone', '%$friendPhoneNumber%');

      if (response == null || response.isEmpty) {
        print('No friends found.');
        return null; // No friends found
      }

      // Map response to a list of friend phone numbers with null checks
      List<String> friendPhones = response.map<String>((friend) {
        final profile = friend['profiles']; // Access profiles object
        if (profile != null && profile['phone'] != null) {
          return profile['phone'] as String; // Extract phone number
        }
        return ''; // Return empty string if phone number is null
      }).where((phone) => phone.isNotEmpty).toList(); // Filter out empty phone numbers

      return friendPhones.isNotEmpty ? friendPhones : null; // Return list of matching friend phone numbers
    } catch (e) {
      print('Error fetching friends: $e');
      return null;
    }
  }


  void handleRealTimeUpdates(List<Map<String, dynamic>> event,  List requestedFriends) {
    final updatedFriends = event.map((data) => FriendsModel.fromMap(data)).toList();
    requestedFriends.assignAll(updatedFriends); // Update the friendsList

  }
}




