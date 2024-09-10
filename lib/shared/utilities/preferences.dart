import 'package:pre_techwiz/shared/utilities/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Preferences {
  static SharedPreferences? instance;

  static const String tenantId = 'tenantId';
  static const String tenantList = 'tenantList';
  static const String domain = 'domain';
  static const String setting = 'setting';
  static const String user = 'user';
  static const String language = 'language';
  static const String notification = 'notification';
  static const String theme = 'theme';
  static const String textScaleFactor = 'textScaleFactor';
  static const String darkOption = 'darkOption';
  static const String font = 'font';
  static const String search = 'search';
  static const String onboarding = 'onboarding';

  static Future<void> setPreferences() async {
    instance = await SharedPreferences.getInstance();
  }

  static Future<bool> clear() {
    return Preferences.instance!.clear();
  }

  static Future<void> reload() {
    return Preferences.instance!.reload();
  }

  static Future<bool> remove(String key) {
    return Preferences.instance!.remove(key);
  }

  static bool containsKey(String key) {
    return Preferences.instance!.containsKey(key);
  }

  // GETTERS

  static dynamic get(String key) {
    return Preferences.instance!.get(key);
  }

  static bool? getBool(String key) {
    return Preferences.instance!.getBool(key);
  }

  static double? getDouble(String key) {
    return Preferences.instance!.getDouble(key);
  }

  static int? getInt(String key) {
    return Preferences.instance!.getInt(key);
  }

  static Set<String> getKeys() {
    return Preferences.instance!.getKeys();
  }

  static String? getString(String key) {
    return Preferences.instance!.getString(key);
  }

  static List<String>? getStringList(String key) {
    return Preferences.instance!.getStringList(key);
  }

  static List<Map>? getMapList(String key) {
    List<String>? list = Preferences.instance!.getStringList(key);
    if (list == null) {
      return null;
    }
    List<Map> result = [];
    for (String item in list) {
      try {
        Map map = jsonDecode(item);
        result.add(map);
      } catch (e) {
        UtilLogger.log('Error decoding JSON: $e');
      }
    }
    return result;
  }

  static Map<String, dynamic>? getMap(String key) {
    String? value = Preferences.instance!.getString(key);
    if (value == null) {
      return null;
    }
    try {
      return jsonDecode(value);
    } catch (e) {
      UtilLogger.log('Error decoding JSON: $e');
      return null;
    }
  }

  static T? getModel<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final String? jsonString = Preferences.instance!.getString(key);
    if (jsonString == null) {
      return null;
    }
    try {
      final Map<String, dynamic> json =
          jsonDecode(jsonString) as Map<String, dynamic>;
      return fromJson(json);
    } catch (e) {
      UtilLogger.log('Error decoding JSON for key $key: $e');
      return null;
    }
  }

  static List<T>? getModelList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    final List<String>? jsonStringList =
        Preferences.instance!.getStringList(key);
    if (jsonStringList == null) {
      return null;
    }

    final List<T> result = [];
    for (final String jsonString in jsonStringList) {
      try {
        final Map<String, dynamic> json =
            jsonDecode(jsonString) as Map<String, dynamic>;
        result.add(fromJson(json));
      } catch (e) {
        UtilLogger.log('Error decoding JSON in list for key $key: $e');
      }
    }
    return result;
  }

  // SETTERS

  static Future<bool> setBool(String key, bool value) {
    return Preferences.instance!.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return Preferences.instance!.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return Preferences.instance!.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) {
    return Preferences.instance!.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return Preferences.instance!.setStringList(key, value);
  }

  static Future<bool> setMap(String key, Map<String, dynamic> value) {
    return Preferences.instance!.setString(key, jsonEncode(value));
  }

  static Future<bool> setMapList(String key, List<Map<String, dynamic>> value) {
    List<String> list = [];
    for (Map<String, dynamic> item in value) {
      list.add(jsonEncode(item));
    }
    return Preferences.instance!.setStringList(key, list);
  }

  static Future<bool> setModel<T>(
      String key, T model, Map<String, dynamic> Function(T) toJson) {
    final String jsonString = jsonEncode(toJson(model));
    return Preferences.instance!.setString(key, jsonString);
  }

  static Future<bool> setModelList<T>(
      String key, List<T> models, Map<String, dynamic> Function(T) toJson) {
    final List<String> jsonStringList =
        models.map((model) => jsonEncode(toJson(model))).toList();
    return Preferences.instance!.setStringList(key, jsonStringList);
  }

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}
