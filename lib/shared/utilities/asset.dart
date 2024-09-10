import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class UtilAsset {
  static Future<Map<String, dynamic>> loadJson(String path) async {
    String content = await rootBundle.loadString(path);
    return jsonDecode(content);
  }
}
