import 'dart:developer';

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
      'total_members':groupModel.totalMembers,
      "default_address": groupModel.defaultAddress,
      "default_longitude": groupModel.defaultLongitude,
      "default_latitude": groupModel.defaultLatitude,
    }).select()
        ;


    // Fetch the inserted data.
    if (response == null || response.isEmpty) {
      throw Exception('Error creating group: Unable to fetch response.');
    }
  }



  static Future<bool> updateGroup(GroupModel groupModel) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('groups')
          .update({
        'name': groupModel.name,
        'created_by': groupModel.createdBy,
        'type': groupModel.type,
        'members': groupModel.members,
        'total_members': groupModel.totalMembers,
        "default_address": groupModel.defaultAddress,
        "default_longitude": groupModel.defaultLongitude,
        "default_latitude": groupModel.defaultLatitude,
      })
          .eq('id', groupModel.id!) // filter by the group's id
          .select();
      print('Group updated successfully');

      return true;
    } catch (e) {
      print('Failed to update group: $e');
      return false;
    }
  }




  static Future<List<GroupModel>> fetchGroupsByType(String type, String userId) async {
    final response = await Supabase.instance.client
        .from('groups')
        .select()
        .eq('type', type).eq('created_by', userId) // Assuming 'group_type' is your column name
        .select();
    if (response.isEmpty ) {

      print('NO Groups ');
      return []; // Return an empty list in case of error
    }
    print("Groups");
    print(response);
    return (response as List<dynamic>)
        .map((item) => GroupModel.fromMap(item)) // Convert to your model
        .toList();
  }
  static Future<List<GroupModel>> getAllGroups(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('groups')
          .select()
          .eq('created_by', userId) // Assuming 'group_type' is your column name
          .select();
      if (response.isEmpty) {
        print('NO Groups ');
        return []; // Return an empty list in case of error
      }
      print("Groups");
      print(response);
      return (response as List<dynamic>)
          .map((item) => GroupModel.fromMap(item)) // Convert to your model
          .toList();
    }catch(e,st){
      log("",error: e,stackTrace: st);
      return [];
    }
  }


  static Future<bool> deleteGroup(String groupId) async {
    try {
      final response = await Supabase.instance.client
          .from('groups')
          .delete()
          .eq('id', groupId)
      ;

      return true;
    }catch(e,st){
      log("Delete Group", error: e,stackTrace: st);
      return false;
    }
  }

  static Future<void> updateGroupMembers(String groupId, List<String> members) async {
    try {
     await Supabase.instance.client
          .from('groups')
          .update({'members': members})
          .eq('id', groupId)
          ;


    } catch (e, st) {
      log("Error updating group $groupId", error: e, stackTrace: st);
    }
  }



}