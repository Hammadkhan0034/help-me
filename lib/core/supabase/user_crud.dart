import 'dart:developer';

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

      if (response != null) {
        final existingUser = UserModel.fromMap(response);
        final mergedUser = existingUser.copyWith(
          name: userModel.name ?? existingUser.name,
          phone: userModel.phone ?? existingUser.phone,
          subscriptionExpiryDate: userModel.subscriptionExpiryDate ?? existingUser.subscriptionExpiryDate ??  DateTime.now().add(Duration(days: 7)),

        );

        final updateData = mergedUser.toMap()
          ..removeWhere((key, value) => value == null);

        await Supabase.instance.client
            .from('profiles')
            .update(updateData)
            .eq('id', userId);

      } else {
         userModel = userModel.copyWith(
          subscriptionExpiryDate: DateTime.now().add(const Duration(days: 7)),
        );
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
        .select('*')
        .eq('id', userId)
        .maybeSingle();
    print(response);
    return response;
  }
  static Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .maybeSingle();
      if (response == null) return null;
      return UserModel.fromMap(response);
    } catch (e, st) {
      log("message", error: e, stackTrace: st);
      return null;
    }
  }
  static Future<void> updateUser(
      String userId, String name, String phone, String fcm) async {
    final response = await Supabase.instance.client.from('profiles').update({
      'name': name,
      'phone': phone,
      'fcm': fcm,
    }).eq('id', userId);

    if (response.error != null) {
      throw Exception('Error updating user: ${response.error!.message}');
    }
  }

  static Future<void> updateFcm(String userId, String fcm) async {
    final response = await Supabase.instance.client.from('profiles').update({
      'fcm': fcm,
    }).eq('id', userId);
  }

  static Future<void> primaryGroup(
      String userId, Map<String, dynamic> data) async {
    final response = await Supabase.instance.client
        .from('profiles')
        .update(data)
        .eq('id', userId);
  }

  static Future<bool> updateUserLocationStatus(
      String userId, bool status) async {
    try {
      final response = await Supabase.instance.client.from('profiles').update({
        'is_location_enabled': status,
      }).eq('id', userId);
      return true;
    } catch (e, st) {
      log("updateUserLocationStatus", error: e, stackTrace: st);
      return false;
    }
  }

  static Future<bool> updateUserActiveStatus(String userId, bool status) async {
    try {
      final response = await Supabase.instance.client.from('profiles').update({
        'is_active': status,
      }).eq('id', userId);
      return true;
    } catch (e, st) {
      log("updateUserActiveStatus", error: e, stackTrace: st);
      return false;
    }
  }

  static Future<bool> updateUserLocationLatLng(
      String userId, double lat, double lng) async {
    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .update({'latitude': lat, 'longitude': lng}).eq('id', userId);

      return true;
    } catch (e, st) {
      log("updateUserLocationLatLng", error: e, stackTrace: st);
      return false;
    }
  }

  static Future<void> updateUserSubscription({required String userId}) async {
    final response = await Supabase.instance.client.from('profiles').update({
      'is_premium': true,
      'subscription_expiry_date':
          DateTime.now().add(const Duration(days: 365)).toIso8601String(),
    }).eq('id', userId);
    if (response.error != null) {
      throw Exception(
          'Error updating User Subscription: ${response.error!.message}');
    }
  }

  static Future<void> cancelUserSubscription({required String userId}) async {
    final response = await Supabase.instance.client.from('profiles').update({
      'is_premium': false,
      'subscription_expiry_date': null,
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
