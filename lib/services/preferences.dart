import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  const Preferences._();

  static late SharedPreferences preferences;
  static const keyUserData = "userData";

  static Future<void> initPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveUserData(Map<String, dynamic>? userData) async {
    return await preferences.setString(keyUserData, json.encode(userData));
  }

  static Map<String, dynamic>? getUserData() {
    final String? value = preferences.getString(keyUserData);
    return value != null ? json.decode(value) : null;
  }
}
