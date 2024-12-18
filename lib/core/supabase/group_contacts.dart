import 'dart:developer';

import 'package:alarm_app/models/contacts_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class GroupContacts{

  static Future<void> addUserToContactModel(UserModel userModel) async {
    final contactData = {
      'phone': userModel.phone,
      'added_at': DateTime.now().toIso8601String(),
      'id': userModel.id,
    };
  try {
    await Supabase.instance.client
        .from('group_contacts')
        .upsert(contactData, onConflict: 'phone');
  }
  catch(error,st){
    log("ERROR ADDING USER",error:error,stackTrace: st);
  }
  }
  // static Future<void> addUserToContactModel(UserModel userModel, ) async {
  //   final contactData = {
  //     'phone': userModel.phone,
  //     'added_at': DateTime.now().toIso8601String(),
  //     'id':userModel.id,
  //   };
  //
  //
  //
  //   final response = await Supabase.instance.client
  //       .from('group_contacts')
  //       .upsert(contactData, onConflict: 'phone');
  //
  //   if (response.error != null) {
  //     throw Exception('Error adding/updating user in group: ${response.error!.message}');
  //   }
  //
  // }

  static Future<List<String>> fetchGroupContacts() async {
    final response = await Supabase.instance.client
        .from('group_contacts')
        .select('phone');

    if (response.isEmpty) {
      throw Exception('Error fetching group contacts: $response');
    }

    // Extract and normalize phone numbers (remove country code if present)
    return List<String>.from(response.map((contact) {
      String phoneNumber = contact['phone'].replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters

      // Dynamically remove the country code if it starts with a '+'
      if (phoneNumber.startsWith('0')) {
        // If the number starts with '0', remove it (common for local dialing)
        return phoneNumber.substring(1); // Remove the leading zero
      } else if (phoneNumber.length > 10) {
        // Check if the first few digits correspond to a country code
        return phoneNumber.substring(phoneNumber.length - 10); // Keep the last 10 digits
      }

      return phoneNumber; // Return the phone number without country code
    }));
  }


static  Future<List<String>> fetchFullGroupContacts() async {
    final response = await Supabase.instance.client
        .from('group_contacts')
        .select('phone');

    if (response.isEmpty) {
      throw Exception('Error fetching group contacts: $response');
    }

    // Assuming the phone numbers are stored in 'phone' column
    return List<String>.from(response.map((contact) => contact['phone']));
  }


  static Future<Map<String, dynamic>?> fetchUserProfileByPhone(String phone) async {
    // Normalize the phone number
    String phoneWithoutCode = phone.length > 10 ? phone.substring(phone.length - 10) : phone;

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('name, id, fcm')
          .ilike('phone', '%$phoneWithoutCode%')
          .single() // Use .single() if you expect only one user to match
          ; // This might vary depending on the client library version

      // Check if the response has an error
      if (response.isEmpty) {
        print('Error fetching user: ');
        return null; // Return null in case of an error
      }

      // If response is successful, return the user data
      return response as Map<String, dynamic>?;
    } catch (e) {
      print('Exception occurred: $e');
      return null; // Return null in case of an exception
    }
  }



// static Future<Map<String, dynamic>?> fetchUserProfileByPhone(String phone) async {
  //   String phoneWithoutCode = phone.length > 10 ? phone.substring(phone.length - 10) : phone;
  //
  //   final response = await Supabase.instance.client
  //       .from('profiles')
  //       .select('name,id,fcm')
  //       .ilike('phone', '%$phoneWithoutCode%')
  //       ;
  //
  //    print(response);
  //
  //   return response.single;
  // }


}