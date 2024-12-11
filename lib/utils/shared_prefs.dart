import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefs {

  late SharedPreferences sharedPreferences;
  static final MySharedPrefs _singleton = MySharedPrefs._internal();

  MySharedPrefs._internal();

  factory MySharedPrefs() {
    return _singleton;
  }

  bool getBool(String key) {
    return sharedPreferences.getBool(key) ?? true;
  }

  setBool(String key, bool value) {
    sharedPreferences.setBool(key, value);
  }

  String? getString(String key) {
    return sharedPreferences.getString(key);
  }

  setString(String key, String value) {
    sharedPreferences.setString(key, value);
  }





  deleteValue(String key) {
    sharedPreferences.remove(key);
  }


}