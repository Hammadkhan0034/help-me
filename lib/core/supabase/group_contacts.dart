import 'package:alarm_app/models/contacts_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class GroupContacts{

  static Future<void> addUserToGroup(UserModel userModel, ) async {
    final contactData = {
      'phone': userModel.phone,
      'added_at': DateTime.now().toIso8601String(),
      'id':userModel.id,
    };



    final response = await Supabase.instance.client
        .from('group_contacts')
        .upsert(contactData, onConflict: 'phone');

    print('Supabase upsert response: ${response.data}');

    if (response.error != null) {
      throw Exception('Error adding/updating user in group: ${response.error!.message}');
    }

  }

static  Future<List<String>> fetchGroupContacts() async {
    final response = await Supabase.instance.client
        .from('group_contacts')
        .select('phone');

    if (response.isEmpty) {
      throw Exception('Error fetching group contacts: $response');
    }

    // Assuming the phone numbers are stored in 'phone' column
    return List<String>.from(response.map((contact) => contact['phone']));
  }


}