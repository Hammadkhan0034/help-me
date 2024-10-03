import 'package:supabase_flutter/supabase_flutter.dart';

class GroupContacts{

 static Future<void> addUserToGroup(String groupId, String userId) async {
    final response = await Supabase.instance.client
        .from('group_contacts')
        .insert({
       'group_id': groupId,
       'user_id': userId,
       'added_at': DateTime.now().toUtc().toIso8601String(),
    })
      ;

    if (response.error != null) {
      throw Exception('Error adding user to group: ${response.error!.message}');
    }
  }

// Read group contacts
  static  Future<List<Map<String, dynamic>>> getGroupContacts(String groupId) async {
    final response = await Supabase.instance.client
        .from('group_contacts')
        .select()

        .eq('group_id', groupId)
   ;

    // if (response.error != null) {
    //   throw Exception('Error fetching group contacts: ${response.error!.message}');
    // }
    return List<Map<String, dynamic>>.from(response);
  }

// Delete a user from a group
  static Future<void> removeUserFromGroup(String groupId, String userId) async {
    final response = await Supabase.instance.client
        .from('group_contacts')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId)
     ;

    if (response.error != null) {
      throw Exception('Error removing user from group: ${response.error!.message}');
    }
  }

}