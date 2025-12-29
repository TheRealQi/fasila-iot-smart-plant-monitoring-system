import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {

  static SharedPreferences? sharedPreferences;

  static onInit() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static dynamic getDataFromSharedPrefrence(String key) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> saveDataToSharedPrefrence(String key, dynamic value) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);
    if (value is double) return await sharedPreferences!.setDouble(key, value);
    if (value == null) {
      return await sharedPreferences!.setString(key, value.toString());
    }

    value = jsonEncode(value);
    return await sharedPreferences!.setString(key, value);
  }

  static Future<bool> clearData(){return sharedPreferences!.clear();}

  static Future<bool> removeData({required key}){
    return sharedPreferences!.remove(key);
  }
}