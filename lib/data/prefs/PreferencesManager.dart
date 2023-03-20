import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static SharedPreferences? prefs;

  static Future<SharedPreferences> getInstance() {
    return SharedPreferences.getInstance();
  }

  static Future<bool> init() async {
    if (prefs != null) return Future.value(true);
    prefs = await getInstance();
    return Future.value(true);
  }

  static void savePref(String key, dynamic value) {
    if (value is bool) {
      prefs!.setBool(key, value);
    } else if (value is int) {
      prefs!.setInt(key, value);
    } else if (value is double) {
      prefs!.setDouble(key, value);
    } else if (value is String) {
      prefs!.setString(key, value);
    } else if (value is List<String>) {
      prefs!.setStringList(key, value);
    } else {
      throw new Exception("Attempting to save non-primitive preference");
    }
  }

  static T? getPref<T>(String key) {
    return prefs!.get(key) as T?;
  }

  static double? getDoublePref<double>(String key) {
    return prefs!.get(key) as double?;
  }

  static T getPrefWithDefault<T>(String key, T defValue) {
    if(prefs != null){
      T? returnValue = prefs!.get(key) as T?;
      return returnValue == null ? defValue : returnValue;
    }
    return defValue;
  }

  static void clean() {
    prefs!.clear();
  }

  static void deleteCardPreferences(String key) {
    prefs!.remove(key);
  }
}