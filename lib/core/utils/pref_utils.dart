//ignore: unused_import
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _sharedPreferences;

  PrefUtils() {
    // init();
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    print('SharedPreference Initialized');
  }

  ///will clear all the data stored in preference
  void clearPreferencesData() async {
    _sharedPreferences!.clear();
  }

  Future<void> setThemeData(String value) {
    return _sharedPreferences!.setString('themeData', value);
  }

  String getThemeData() {
    try {
      return _sharedPreferences!.getString('themeData')!;
    } catch (e) {
      return 'primary';
    }
  }

  setLoginToken(String token) {
    return _sharedPreferences!.setString("token", token);
  }

  String? getLoginToken() {
    try {
      return _sharedPreferences!.getString("token");
    } catch (e) {
      return null;
    }
  }

  setUserName(String username) {
    return _sharedPreferences!.setString("username", username);
  }

  String getUsername() {
    try {
      return _sharedPreferences!.getString("username")!;
    } catch (e) {
      return "My name";
    }
  }

  clearToken() async {
    await _sharedPreferences!.remove("token");
  }
}
