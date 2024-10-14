import 'package:alarm_app/core/supabase/group_contacts.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/features/auth/screen/singnup_screen.dart';
import 'package:alarm_app/features/help/screens/help_me_screen.dart';
import 'package:alarm_app/models/contacts_model.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:alarm_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../servies/notification_service.dart';
import '../screen/otp_screen.dart';

class AuthController extends GetxController {
  var phoneNumber = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  Rx<UserModel> userModel =
      UserModel(id: 'id', name: 'name', phone: 'phone', fcm: 'fcm').obs;
  Rx<ContactsModel> contactModel = const ContactsModel(phone: '').obs;
  Future<void> signUp() async {
    print("PHONE NUMBER : ${phoneNumber.value}");
    try {
      await supabaseClient.auth.signInWithOtp(
        phone: phoneNumber.value,
      );
      Utils.showSuccessSnackBar(title: "OTP send", description: "OTP send to ${phoneNumber.value}");
      Get.to(OtpScreen());
    } on AuthException catch (error) {
      if (kDebugMode) {
        print('AuthException during sign-up: ${error.message}');
      }

      Utils.showErrorSnackBar(
          title: "Authentication Error", description: error.message);
    } catch (error) {
      if (kDebugMode) {
        print('Unexpected error during sign-up: $error');
      }
      Utils.showErrorSnackBar(
          title: "Error",
          description: "An unexpected error occurred. Please try again later.");
    } finally {
      if (kDebugMode) {
        print("OTP request completed for ${phoneNumber.value}");
      }
    }
  }

  // Future<String?> verifyOtp(String otp) async {
  //   NotificationService notificationService = NotificationService();
  //   String? fcmToken = await notificationService.getDeviceToken();
  //   try {
  //     final AuthResponse? res = await supabaseClient.auth.verifyOTP(
  //       type: OtpType.sms,
  //       token: otp,
  //       phone:phoneNumber.value,
  //     );
  //
  //     if (res == null) {
  //       print("AuthResponse is null");
  //       Utils.showErrorSnackBar(title: "Verification Failed", description: "Unable to verify OTP. Please try again later");
  //       return null;
  //     }
  //     final User? user = res.user;
  //     final Session? session = res.session;
  //
  //     if (session != null && user != null) {
  //       userModel.value = UserModel(
  //         id: user.id,
  //         name: nameController.text.trim(),
  //         phone: user.phone!,
  //         fcm: fcmToken ?? "",
  //       );
  //       await UserCrud.insertUserData(user.id, userModel.value);
  //
  //       Get.to(() => const HelpMeScreen());
  //       await getProfile();
  //
  //       contactModel.value =
  //           ContactsModel(phone: userModel.value.phone.toString());
  //       await GroupContacts.addUserToContactModel(userModel.value);
  //       return user.id;
  //     } else {
  //       return null;
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print("Error verifying OTP: $error");
  //     }
  //     return null;
  //   }
  // }

  Future<String?> verifyOtp(String otp) async {
    NotificationService notificationService = NotificationService();
    String? fcmToken = await notificationService.getDeviceToken();

    try {
      final AuthResponse? res = await supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        token: otp,
        phone: phoneNumber.value, // phone number from your controller
      );

      if (res == null) {
        print("AuthResponse is null");
        Utils.showErrorSnackBar(
          title: "Verification Failed",
          description: "Unable to verify OTP. Please try again later",
        );
        return null;
      }

      final User? user = res.user;
      final Session? session = res.session;

      if (session != null && user != null) {
        // Create UserModel from response
        userModel.value = UserModel(
          id: user.id,
          name: nameController.text.trim(), // Assuming you take this from a text field
          phone: user.phone!,
          fcm: fcmToken ?? "",
        );

        // Insert user data into the database
        await UserCrud.insertUserData(user.id, userModel.value);

        // Navigate to the next screen after successful OTP verification
        Get.to(() => const HelpMeScreen());

        // Fetch profile information
          await getProfile();

        // Update contact model and add user to contacts
        contactModel.value = ContactsModel(phone: userModel.value.phone.toString());
        await GroupContacts.addUserToContactModel(userModel.value);

        return user.id;
      } else {
        return null;
      }
    } catch (error) {

      if (kDebugMode) {
        print("Error verifying OTP: $error");
      }
      return null;
    }
  }


  Future<void> getProfile() async {
    try {
      final userId = supabaseClient.auth.currentSession!.user.id;
      print("This is ID comming from the supabse ${userId}");
      final response = await UserCrud.getUser(userId);

      print("This is ID comming from the supabse ${response}");

      if (response != null) {
        userModel.value = UserModel.fromMap(response);
        if (kDebugMode) {
          print("User Model fetched ${userModel.toString()}");
        }
      } else {
        Utils.showErrorSnackBar(title: 'Error', description: 'User Not Found');
        Get.off(()=>AuthScreen());
      }
    } on PostgrestException catch (error) {
      if (kDebugMode) {
        print('Error fetching user profile: ${error.message}');
      }
      Utils.showErrorSnackBar(
          title: 'Error', description: 'Could not fetch user profile.');
    } catch (error) {
      if (kDebugMode) {
        print('Unexpected error: $error');
      }
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
}
