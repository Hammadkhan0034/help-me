import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user_model.dart';
class UserCrud{



static  Future<void> insertUserData(String userId, UserModel userModel) async {
    try {
      final response = await  Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (response.isNotEmpty) {
        await await Supabase.instance.client
            .from('profiles')
            .update(userModel.toMap())
            .eq('id', userId);
        print("User updated: ${userModel.id}");
      } else {
        await await Supabase.instance.client.from('profiles').insert(userModel.toMap());
        print("User inserted: ${userModel.id}");
      }

    } catch (error) {
      print(error);
     throw Exception('Error creating user: ${error.toString()}');
    }
  }
static  Future<Map<String, dynamic>?> getUser(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .match({'id':userId}).maybeSingle();

    return response;
  }

 static Future<void> updateUser(String userId, String name, String phone, String email) async {
    final response = await Supabase.instance.client
        .from('users')
        .update({
      'name': name,
      'phone': phone,
      'email': email,
    })
        .eq('id', userId)
    ;

    if (response.error != null) {
      throw Exception('Error updating user: ${response.error!.message}');
    }
  }

// Delete a user
static  Future<void> deleteUser(String userId) async {
    final response = await Supabase.instance.client
        .from('users')
        .delete()
        .eq('id', userId)
    ;

    if (response.error != null) {
      throw Exception('Error deleting user: ${response.error!.message}');
    }
  }
}

