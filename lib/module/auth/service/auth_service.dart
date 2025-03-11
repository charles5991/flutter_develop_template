import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String KEY_IS_LOGGED_IN = 'isLoggedIn';
  static const String KEY_USER_PHONE = 'userPhone';
  static const String KEY_SEEN_ONBOARDING = 'seen_onboarding';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGED_IN) ?? false;
  }

  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_SEEN_ONBOARDING) ?? false;
  }

  static Future<void> login(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_IS_LOGGED_IN, true);
    await prefs.setString(KEY_USER_PHONE, phone);
  }

  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_SEEN_ONBOARDING, true);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_IS_LOGGED_IN);
    await prefs.remove(KEY_USER_PHONE);
    // Don't clear onboarding status on logout
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear everything on fresh install
  }
} 