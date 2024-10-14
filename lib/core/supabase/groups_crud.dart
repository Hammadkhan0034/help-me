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
      'members': groupModel.contacts,
    })
        .select();  // Fetch the inserted data.
Utils.showSuccessSnackBar(title: "Group Created", description: "Your Group ${groupModel.name} is created");
    if (response == null || response.isEmpty) {
      throw Exception('Error creating group: Unable to fetch response.');
    }
  }

// Read a group by ID
  static Future<Map<String, dynamic>?> getGroup(String groupId) async {
    final response = await Supabase.instance.client
        .from('groups')
        .select()
        .eq('id', groupId)
        .single()
 ;

    // if (response.error != null) {
    //   throw Exception('Error fetching group: ${response.error!.message}');
    // }
    return response;
  }

// Update group details
  static Future<void> updateGroup(String groupId, String name, String type) async {
    final response = await Supabase.instance.client
        .from('groups')
        .update({
      'name': name,
      'type': type,
    })
        .eq('id', groupId)
        ;

    if (response.error != null) {
      throw Exception('Error updating group: ${response.error!.message}');
    }
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