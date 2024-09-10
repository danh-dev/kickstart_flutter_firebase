import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class UtilLogger {
  static log([String tag = "LOGGER", dynamic msg]) {
    if (kDebugMode) {
      print('$tag: $msg');
    }
  }
}
