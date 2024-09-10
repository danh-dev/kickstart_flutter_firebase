import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/message/message_bloc.dart';
import 'package:pre_techwiz/models/model_gps.dart';

class Utils {
  static fieldFocusChange(
    BuildContext context,
    FocusNode current,
    FocusNode next,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static hiddenKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<String?> getDeviceToken() async {
    await FirebaseMessaging.instance.requestPermission();
    return await FirebaseMessaging.instance.getToken();
  }

  static Future<GPSModel?> getLocations() async {
    try {
      LocationPermission? permissionStatus;
      permissionStatus = await Geolocator.checkPermission();
      if (permissionStatus == LocationPermission.denied) {
        permissionStatus = await Geolocator.requestPermission();
        if (permissionStatus == LocationPermission.denied) {
          return null;
        }
      }

      Position location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return GPSModel(
        longitude: location.longitude,
        latitude: location.latitude,
      );
    } catch (e) {
      AppBloc.messageBloc.add(MessageEvent(message: e.toString()));
    }
    return null;
  }
}
