import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pre_techwiz/blocs/app_bloc.dart';
import 'package:pre_techwiz/blocs/application/application_state.dart';
import 'package:pre_techwiz/shared/configs/language.dart';
import 'package:pre_techwiz/shared/configs/theme.dart';
import 'package:pre_techwiz/models/model_theme.dart';
import 'package:pre_techwiz/shared/utilities/logger.dart';
import 'package:pre_techwiz/shared/utilities/preferences.dart';

class ApplicationCubit extends Cubit<ApplicationState> {
  ApplicationCubit() : super(ApplicationStateLoading());

  ///On Setup Application
  void onSetup() async {
    try {
      ///Get old value from preferences
      await Preferences.setPreferences();
      final oldTheme = Preferences.getString(Preferences.theme);
      final oldFont = Preferences.getString(Preferences.font);
      final oldLanguage = Preferences.getString(Preferences.language);
      final oldDarkOption = Preferences.getString(Preferences.darkOption);
      final oldTextScale = Preferences.getDouble(Preferences.textScaleFactor);

      DarkOption darkOption = AppTheme.darkThemeOption;
      String font = AppTheme.defaultFont;
      ThemeModel theme = AppTheme.defaultTheme;
      Locale language = AppLanguage.defaultLanguage;

      ///Setup Language
      if (oldLanguage != null && oldLanguage.isNotEmpty) {
        language = Locale(oldLanguage);
      }

      ///Find font support available [Dart null safety issue]
      if (oldFont != null && oldFont.isNotEmpty) {
        font = AppTheme.fontSupport.firstWhere(
          (item) => item == oldFont,
          orElse: () => AppTheme.defaultFont,
        );
      }

      ///Setup theme
      if (oldTheme != null && oldTheme.isNotEmpty) {
        try {
          theme = ThemeModel.fromJson(jsonDecode(oldTheme));
        } catch (e) {
          UtilLogger.log("ERROR", "Failed to parse theme: $e");
          theme = AppTheme.defaultTheme;
        }
      }

      ///check old dark option
      if (oldDarkOption != null) {
        switch (oldDarkOption) {
          case 'off':
            darkOption = DarkOption.alwaysOff;
            break;
          case 'on':
            darkOption = DarkOption.alwaysOn;
            break;
          default:
            darkOption = DarkOption.dynamic;
        }
      }

      ///Setup application & setting
      final List<dynamic> results = await Future.wait<dynamic>([
        Firebase.initializeApp(),
      ]);

      ///Authentication begin check
      // AppBloc.authenticateCubit.onCheck();

      ///Setup Theme & Font with dark Option
      ThemeState appTheme = await _saveTheme(
        theme: theme,
        font: font,
        darkOption: darkOption,
        textScaleFactor: oldTextScale,
      );

      emit(ApplicationStateSuccess(
        language: language,
        theme: appTheme,
      ));
    } catch (e) {
      UtilLogger.log("ERROR", "Failed in onSetup: $e");
      emit(ApplicationStateFailure(error: e.toString()));
    }
  }

  ///On Change Theme
  void onChangeTheme({
    ThemeModel? theme,
    String? font,
    DarkOption? darkOption,
    double? textScaleFactor,
  }) async {
    if (state is ApplicationStateSuccess) {
      ApplicationStateSuccess current = state as ApplicationStateSuccess;
      theme ??= current.theme.theme;
      font ??= current.theme.font;
      darkOption ??= current.theme.darkOption;
      textScaleFactor ??= current.theme.textScaleFactor ?? 1.0;

      ThemeState appTheme = await _saveTheme(
        theme: theme,
        font: font,
        darkOption: darkOption,
        textScaleFactor: textScaleFactor,
      );

      emit(ApplicationStateSuccess(
        language: current.language,
        theme: appTheme,
      ));
    }
  }

  ///On Change Language
  void onChangeLanguage(Locale locale) {
    if (state is ApplicationStateSuccess) {
      ApplicationStateSuccess current = state as ApplicationStateSuccess;

      ///Preference save
      Preferences.setString(
        Preferences.language,
        locale.languageCode,
      );
      emit(ApplicationStateSuccess(
        language: locale,
        theme: current.theme,
      ));
    }
  }

  Future<ThemeState> _saveTheme({
    required ThemeModel theme,
    required String font,
    required DarkOption darkOption,
    double? textScaleFactor,
  }) async {
    ThemeState themeState = ThemeState.fromDefault();

    ///Dark mode option
    switch (darkOption) {
      case DarkOption.dynamic:
        Preferences.setString(Preferences.darkOption, 'dynamic');
        themeState = ThemeState(
          theme: theme,
          lightTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            font: font,
          ),
          darkTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            font: font,
          ),
          font: font,
          darkOption: darkOption,
          textScaleFactor: textScaleFactor,
        );
        break;
      case DarkOption.alwaysOn:
        Preferences.setString(Preferences.darkOption, 'on');
        themeState = ThemeState(
          theme: theme,
          lightTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            font: font,
          ),
          darkTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.dark,
            font: font,
          ),
          font: font,
          darkOption: darkOption,
          textScaleFactor: textScaleFactor,
        );
        break;
      case DarkOption.alwaysOff:
        Preferences.setString(Preferences.darkOption, 'off');
        themeState = ThemeState(
          theme: theme,
          lightTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            font: font,
          ),
          darkTheme: AppTheme.getTheme(
            theme: theme,
            brightness: Brightness.light,
            font: font,
          ),
          font: font,
          darkOption: darkOption,
          textScaleFactor: textScaleFactor,
        );
        break;
    }

    ///Theme
    Preferences.setString(
      Preferences.theme,
      jsonEncode(themeState.theme.toJson()),
    );

    ///Font
    Preferences.setString(Preferences.font, themeState.font);

    ///Text Scale
    if (themeState.textScaleFactor != null) {
      Preferences.setDouble(
        Preferences.textScaleFactor,
        themeState.textScaleFactor!,
      );
    }

    return themeState;
  }
}
