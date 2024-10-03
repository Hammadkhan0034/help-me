import 'package:alarm_app/core/supabase/exceptions/supabase_exception.dart';
import 'package:alarm_app/core/supabase/user_crud.dart';
import 'package:alarm_app/features/help/screens/help_me_screen.dart';
import 'package:alarm_app/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screen/otp_screen.dart';

class AuthController extends GetxController {
  String phoneNumber = '';
final  TextEditingController nameController= TextEditingController();
  final SupabaseClient supabaseClient = Supabase.instance.client;
  Rx<UserModel> userModel =
      UserModel(id: 'id', name: 'name', phone: 'phone', fcm: 'fcm').obs;
  Future<void> signUp() async {
    try {
      await supabaseClient.auth.signInWithOtp(
        phone: phoneNumber,
      );
      Get.to(OtpScreen());
    } catch (error) {
      print('Error during sign-up: $error');
      throw Exception(error);

    }
  }
  Future<String?> verifyOtp(String otp) async {
    try {
      final AuthResponse res = await supabaseClient.auth.verifyOTP(
        type: OtpType.sms,
        token: otp,
        phone: phoneNumber,
      );

      final User? user = res.user;
      final Session? session = res.session;

      if (session != null && user != null) {
        userModel.value = UserModel(
          id: user.id,
          name: nameController.text.trim(),
          phone: user.phone!,
          fcm: 'fcm_token',
        );
        await UserCrud.insertUserData(user.id, userModel.value);
        Get.to(const HelpMeScreen());

        return user.id;
      } else {

        return null;
      }
    } catch (error) {
      print("Error verifying OTP: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await supabaseClient.auth.signOut();
  }
}
