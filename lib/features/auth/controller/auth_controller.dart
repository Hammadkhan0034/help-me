import 'dart:developer';

import 'package:alarm_app/core/supabase/group_contacts.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/features/auth/screen/singnup_screen.dart';
import 'package:alarm_app/features/group/controller/group_controller.dart';
import 'package:alarm_app/features/help/screens/help_me_screen.dart';
import 'package:alarm_app/models/contacts_model.dart';
import 'package:alarm_app/models/group_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:alarm_app/utils/shared_prefs.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screen/otp_screen.dart';

class AuthController extends GetxController {
  var phoneNumber = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  var isResendingOtp = false.obs;
  var isVerifyingOtp = false.obs;

  Rx<UserModel> userModel = UserModel(
          id: 'id',
          name: 'name',
          phone: 'phone',
          fcm: 'fcm',
          isLocationEnabled: false)
      .obs;
  Rx<ContactsModel> contactModel = const ContactsModel(phone: '').obs;
  Future<void> signUp() async {
    print("PHONE NUMBER : ${phoneNumber.value}");
    try {
      await supabaseClient.auth.signInWithOtp(
        phone: phoneNumber.value,
      );
      Utils.showSuccessSnackBar(
          title: "OTP send", description: "OTP send to ${phoneNumber.value}");
      Get.to(OtpScreen());
    } on AuthException catch (error) {
      Utils.showErrorSnackBar(title: "message", description: error.message);
      if (kDebugMode) {
        print('AuthException during sign-up: ${error.message}');
      }
    } catch (error) {
      if (kDebugMode) {
        Utils.showErrorSnackBar(
            title: "message", description: error.toString());

        print('Unexpected error during sign-up: $error');
      }
    } finally {
      if (kDebugMode) {
        print("OTP request completed for ${phoneNumber.value}");
      }
    }
  }

  Future<void> resendOtp(String phone) async {
    isResendingOtp.value = true;
    try {
      await supabaseClient.auth.signInWithOtp(phone: phone);

      Utils.showSuccessSnackBar(
          title: "OTP Sent", description: "OTP has been sent to $phone");
    } on AuthException catch (error) {
      Utils.showErrorSnackBar(
          title: "Authentication Error", description: error.message);
    } catch (error) {
      Utils.showErrorSnackBar(
          title: "Error",
          description: "An unexpected error occurred. Please try again.");
    } finally {
      isResendingOtp.value = false;
    }
  }

  Future<String?> verifyOtp(String otp) async {
    isVerifyingOtp.value = true;
    // NotificationService notificationService = NotificationService();
    //  String? fcmToken = await notificationService.getDeviceToken();

    try {
      final AuthResponse res = await supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        token: otp,
        phone: phoneNumber.value,
      );
      isVerifyingOtp.value = false;

      // Ensure both user and session are available
      if (res.user == null || res.session == null) {
        print("User or Session is null in AuthResponse");
        Utils.showErrorSnackBar(
          title: "Verification Failed",
          description: "Invalid OTP or session could not be established",
        );
        return null;
      }

      final User? user = supabaseClient.auth.currentUser;

      userModel.value = UserModel(
        id: user!.id,
        name: nameController.text.trim(),
        phone: user.phone!,
        fcm: "",
        isLocationEnabled: false,
      );

      await UserCrud.insertUserData(user.id, userModel.value);
      Get.offAll(() => HelpMeScreen());
      await getProfile();
      MySharedPrefs().sharedPreferences.setBool("isLoggedIn", true);
      contactModel.value =
          ContactsModel(phone: userModel.value.phone.toString());
      await GroupContacts.addUserToContactModel(userModel.value);

      return user.id;
    } catch (error, st) {
      Utils.showErrorSnackBar(title: "message", description: error.toString());
      log("ERROR verifying otp ", error: error, stackTrace: st);

      return null;
    } finally {
      isVerifyingOtp.value = false;
    }
  }

  updatePrimaryIndoorGroup(GroupModel? groupModel) async {
    try {
      UserCrud.primaryGroup(userModel.value.id, {
        'primary_indoor': groupModel?.id,
        // 'primary_outdoor': phone,
      });
      userModel.value = userModel.value.copyWith(primaryIndoor: groupModel?.id);
      Get.find<GroupController>().primaryIndoor = groupModel;
    } catch (e, st) {
      log("", error: e, stackTrace: st);
    }
  }

  updatePrimaryOutdoorGroup(GroupModel? groupModel) async {
    try {
      UserCrud.primaryGroup(userModel.value.id, {
        'primary_outdoor': groupModel?.id,
        // 'primary_outdoor': phone,
      });
      userModel.value =
          userModel.value.copyWith(primaryOutdoor: groupModel?.id);
      Get.find<GroupController>().primaryOutdoor = groupModel;
    } catch (e, st) {
      log("", error: e, stackTrace: st);
    }
  }

  Future<int> getProfile() async {
    try {
      final userId = supabaseClient.auth.currentSession!.user.id;
      print("This is ID coming from Supabase: $userId");
      final response = await UserCrud.getUser(userId);
      print("This is response coming from Supabase: $response");

      if (response != null) {
        userModel.value = UserModel.fromMap(response);
        if (kDebugMode) {
          print("User Model fetched: ${userModel.toString()}");
        }
        return 1; // Return 1 when profile is successfully fetched
      } else {
        Utils.showErrorSnackBar(title: 'Error', description: 'User Not Found');
        Get.off(() => AuthScreen());
      }
    } on PostgrestException catch (error) {
      if (kDebugMode) {
        print('Error fetching user profile: ${error.message}');
      }
      Utils.showErrorSnackBar(
          title: 'Error', description: 'Could not fetch user profile.');
    } catch (error) {
      if (MySharedPrefs().sharedPreferences.getBool("isLoggedIn") ?? false) {
        Get.offAll(HelpMeScreen());
      } else {
        Utils.showErrorSnackBar(
            title: 'Error', description: 'An unexpected error occurred');
      }
    }
    return 0; // Return 0 in case of failure
  }

  void checkUserSubscription() async {
    try {
      // await UserCrud.updateUserSubscription(userModel.value);
      Utils.showSuccessSnackBar(
          title: 'Success', description: 'Profile updated successfully');
    } on PostgrestException catch (error) {
      Utils.showErrorSnackBar(title: 'Error', description: error.message);
    } catch (error) {
      Utils.showErrorSnackBar(
          title: 'Error', description: 'An unexpected error occurred');
    }
  }

  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (error) {
      Utils.showErrorSnackBar(
        title: 'Error',
        description: error.message,
      );
    } catch (error) {
      Utils.showErrorSnackBar(
          title: 'Error', description: 'An unexpected error occurred');
    } finally {
      Get.offAll(() => AuthScreen());
    }
  }

  void deleteAccount() async {
    final isOk = await Utils.askForConfirmation(
        Get.context!, "delete this account", "Delete Account");
    if (!isOk) return;

    try {
      final isOk = await deleteUser(userModel.value.id);
      if (!isOk) {
        Get.snackbar(
            "Delete User", "Couldn't delete your user account. Try again");
        print("asdfghjklzxcvbnm,qwertyuio");
        return;
      }
      await UserCrud.updateUserActiveStatus(userModel.value.id, false);
      Get.offAll(AuthScreen());
    } catch (e, st) {
      Get.snackbar(
          "Delete User", "Couldn't delete your user account. Try again");
      log("Delete user", error: e, stackTrace: st);
    }
  }

  Future<bool> deleteUser(String userId) async {
    final supabaseUrl = dotenv.env['PROJECT_URL']!;
    final serviceRoleKey =
        dotenv.env['SERVICE_KEY']!; // Use securely in production

    print("url: $supabaseUrl\n token: $serviceRoleKey");
    final uri = Uri.parse('$supabaseUrl/auth/v1/admin/users/$userId');

    try {
      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $serviceRoleKey',
          'apikey': serviceRoleKey, // Required for Supabase API

          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch (error, st) {
      log("delete user", error: error, stackTrace: st);
      return false;
    }
  }
}
