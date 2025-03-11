import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';  // NOT 'package:shared_preferences.dart'

import '../../res/style/color_styles.dart';

/// 状态栏样式
SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness,
    [Color? backgroundColor]) {
  final SystemUiOverlayStyle style = brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
  // For backward compatibility, create an overlay style without system navigation bar settings.
  return SystemUiOverlayStyle(
    statusBarColor: backgroundColor,
    statusBarBrightness: style.statusBarBrightness,
    statusBarIconBrightness: style.statusBarIconBrightness,
    systemStatusBarContrastEnforced: style.systemStatusBarContrastEnforced,
  );
}

/// 下面 注解 没写反！！！，给白色，图标/字体 实际情况是 黑色，反之 给黑色，图标/字体 是 白色

/// 状态栏 背景透明，图标/字体 黑色
SystemUiOverlayStyle get overlayBlackStyle =>
    _systemOverlayStyleForBrightness(
      ThemeData.estimateBrightnessForColor(ColorStyles.color_FFFFFF), // 状态栏图标字体颜色
      ColorStyles.color_transparent, // 状态栏背景色
    );

/// 状态栏 背景透明，图标/字体 白色
SystemUiOverlayStyle get overlayWhiteStyle =>
    _systemOverlayStyleForBrightness(
      ThemeData.estimateBrightnessForColor(ColorStyles.color_000000), // 状态栏图标字体颜色
      ColorStyles.color_transparent, // 状态栏背景色
    );

// Add these constants
class Global {
  // Session keys
  static const String KEY_IS_LOGGED_IN = 'isLoggedIn';
  static const String KEY_USER_PHONE = 'userPhone';
  static const String KEY_FIRST_LAUNCH = 'first_launch';

  // Session management methods
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_IS_LOGGED_IN) ?? false;
  }

  static Future<void> saveLoginSession(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_IS_LOGGED_IN, true);
    await prefs.setString(KEY_USER_PHONE, phone);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(KEY_IS_LOGGED_IN);
    await prefs.remove(KEY_USER_PHONE);
  }

  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(KEY_FIRST_LAUNCH) ?? true;
  }

  static Future<void> markFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(KEY_FIRST_LAUNCH, false);
  }
}