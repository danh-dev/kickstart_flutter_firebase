import 'package:flutter/material.dart';
import 'package:pre_techwiz/screens/signin/signin.dart';
import 'package:pre_techwiz/screens/signup/signup.dart';

class Routes {
  static const String home = "/home";
  static const String account = "/account";
  static const String signIn = "/sign-in";
  static const String signUp = "/sign-up";
  static const String forgotPassword = "/forgot-password";
  static const String profile = "/profile";
  static const String editProfile = "/edit-profile";
  static const String changePassword = "/change-password";
  static const String changeLanguage = "/change-language";
  static const String setting = "/setting";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            return SignIn(from: settings.arguments);
          },
          fullscreenDialog: true,
        );
      case signUp:
        return MaterialPageRoute(builder: (context) {
          return const SignUp();
        });
      // case profile:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return Profile(user: settings.arguments as UserModel);
      //     },
      //   );
      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          fullscreenDialog: true,
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
