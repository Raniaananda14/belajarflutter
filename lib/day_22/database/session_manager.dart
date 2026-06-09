import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    themeNotifier.value = _prefs.getString(_keyThemeMode) ?? "light";
  }

  static const String _keyThemeMode = "day22_theme_mode";
  static const String _keyIsLoggedIn = "day22_is_logged_in";
  static const String _keyName = "day22_user_name";
  static const String _keyEmail = "day22_user_email";
  static const String _keyNik = "day22_user_nik";
  static const String _keyBusinessInfo = "day22_business_info";
  static const String _keyProfileImage = "day22_profile_image";
  static const String _keyNotifSales = "day22_notif_sales";
  static const String _keyNotifTarget = "day22_notif_target";
  static const String _keyNotifSystem = "day22_notif_system";

  static final ValueNotifier<String> themeNotifier = ValueNotifier<String>(
    "light",
  );

  static Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_keyThemeMode, mode);
    themeNotifier.value = mode;
  }

  static Future<void> saveUser({
    required String name,
    required String email,
    required String nik,
    String? profileImage,
  }) async {
    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyNik, nik);
    if (profileImage != null) {
      await _prefs.setString(_keyProfileImage, profileImage);
    } else {
      await _prefs.remove(_keyProfileImage);
    }
    await _prefs.setBool(_keyIsLoggedIn, true);
    // Initialize default business info if empty
    if (_prefs.getString(_keyBusinessInfo) == null) {
      await _prefs.setString(_keyBusinessInfo, "BizGrow Jakarta Barat");
    }
  }

  static Future<void> updateProfile({
    required String name,
    required String email,
    required String nik,
  }) async {
    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyNik, nik);
  }

  static Future<void> updateProfileImage(String? imagePath) async {
    if (imagePath != null) {
      await _prefs.setString(_keyProfileImage, imagePath);
    } else {
      await _prefs.remove(_keyProfileImage);
    }
  }

  static Future<void> updateBusinessInfo(String businessInfo) async {
    await _prefs.setString(_keyBusinessInfo, businessInfo);
  }

  static Future<void> updateNotificationSettings({
    required bool sales,
    required bool target,
    required bool system,
  }) async {
    await _prefs.setBool(_keyNotifSales, sales);
    await _prefs.setBool(_keyNotifTarget, target);
    await _prefs.setBool(_keyNotifSystem, system);
  }

  static String get name => _prefs.getString(_keyName) ?? "Rania Ananda";
  static String get email => _prefs.getString(_keyEmail) ?? "rania@gmail.com";
  static String get nik => _prefs.getString(_keyNik) ?? "1234567890123456";
  static String get businessInfo =>
      _prefs.getString(_keyBusinessInfo) ?? "BizGrow Jakarta Barat";
  static String get profileImage => _prefs.getString(_keyProfileImage) ?? "";

  static bool get notifSales => _prefs.getBool(_keyNotifSales) ?? true;
  static bool get notifTarget => _prefs.getBool(_keyNotifTarget) ?? true;
  static bool get notifSystem => _prefs.getBool(_keyNotifSystem) ?? false;

  static bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;

  static Future<void> clear() async {
    await _prefs.remove(_keyName);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyNik);
    await _prefs.remove(_keyBusinessInfo);
    await _prefs.remove(_keyProfileImage);
    await _prefs.remove(_keyNotifSales);
    await _prefs.remove(_keyNotifTarget);
    await _prefs.remove(_keyNotifSystem);
    await _prefs.setBool(_keyIsLoggedIn, false);
  }
}
