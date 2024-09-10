import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pre_techwiz/models/model_device.dart';

class Application {
  static bool debug = kDebugMode;
  static DeviceModel? device;
  static PackageInfo? packageInfo;

  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
