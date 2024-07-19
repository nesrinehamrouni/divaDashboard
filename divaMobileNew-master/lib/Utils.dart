import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static const String _tokenKey = 'auth_token';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> setToken(String? newToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (newToken != null) {
      await prefs.setString(_tokenKey, newToken);
    } else {
      await prefs.remove(_tokenKey);
    }
  }

  static Future<void> clearToken() async {
    await setToken(null);
  }
}