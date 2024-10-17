import 'package:alarm_app/models/group_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupCrud{
  // Create a new group
  static Future<void> createGroup(GroupModel groupModel) async {

    final response = await Supabase.instance.client
        .from('groups')
        .insert({
      'id': groupModel.id,
      'name': groupModel.name,
      'created_by': groupModel.createdBy,
      'type': groupModel.type,
      'members': groupModel.members,
      'total_members':groupModel.totalMembers
    }).select()
        ;


    // Fetch the inserted data.
    if (response == null || response.isEmpty) {
      throw Exception('Error creating group: Unable to fetch response.');
    }
  }

  static Future<List<GroupModel>> fetchGroupsByType(String type, String userId) async {
    final response = await Supabase.instance.client
        .from('groups')
        .select()
        .eq('type', type).eq('created_by', userId) // Assuming 'group_type' is your column name
        .select();
    if (response.isEmpty ) {
      print('Error fetching groups:');
      return []; // Return an empty list in case of error
    }
    print("Groups");
    print(response);
    return (response as List<dynamic>)
        .map((item) => GroupModel.fromMap(item)) // Convert to your model
        .toList();
  }


// Delete a group
  static Future<void> deleteGroup(String groupId) async {
    final response = await Supabase.instance.client
        .from('groups')
        .delete()
        .eq('id', groupId)
        ;

    if (response.error != null) {
      throw Exception('Error deleting group: ${response.error!.message}');
    }
  }


}