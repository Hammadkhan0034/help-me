import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_model.dart';

class UserCrud {

  static Future<void> insertUserData(String userId, UserModel userModel) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null && response.isNotEmpty) {
        // User exists, proceed with update
        await Supabase.instance.client
            .from('profiles')
            .update(userModel.toMap())
            .eq('id', userId);
        if (kDebugMode) {
          print("User updated: ${userModel.id}");
        }
      } else {
        // User doesn't exist, proceed with insert
        await Supabase.instance.client
            .from('profiles')
            .insert(userModel.toMap());
        print("User inserted: ${userModel.id}");
      }
    } catch (error) {
      print("Error in insertUserData: $error");
      throw Exception('Error creating or updating user: ${error.toString()}');
    }
  }

  static Future<Map<String, dynamic>?> getUser(String userId) async {
    final response = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    return response;
  }

  static Future<void> updateUser(
      String userId, String name, String phone, String fcm) async {
    final response = await Supabase.instance.client.from('profiles').update({
      'name': name,
      'phone': phone,
      'fcm':fcm
    }).eq('id', userId);

    if (response.error != null) {
      throw Exception('Error updating user: ${response.error!.message}');
    }
  }

// Delete a user
  static Future<void> deleteUser(String userId) async {
    final response =
        await Supabase.instance.client.from('users').delete().eq('id', userId);

    if (response.error != null) {
      throw Exception('Error deleting user: ${response.error!.message}');
    }
  }
}
