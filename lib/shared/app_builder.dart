import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AppBuilder {
  static Widget build(BuildContext context, Widget? child) {
    final builders = [
      (BuildContext context, Widget? child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          ),
      EasyLoading.init(),
      // Thêm các builder khác ở đây nếu cần
      // Package1.init(),
      // Package2.init(),
    ];

    return builders.reversed.fold<Widget>(
      child!,
      (Widget? accumulator, TransitionBuilder builder) =>
          builder(context, accumulator),
    );
  }
}
