import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String KEY_LOGIN_STATE = "login_state";
  static const String KEY_TOKEN = "token";

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_LOGIN_STATE, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_LOGIN_STATE) ?? false;
  }

  static Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(KEY_TOKEN, token);
    } else {
      await prefs.remove(KEY_TOKEN);
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KEY_TOKEN);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}