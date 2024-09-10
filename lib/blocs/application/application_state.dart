import 'package:flutter/material.dart';
import 'package:pre_techwiz/shared/configs/theme.dart';
import 'package:pre_techwiz/models/model_theme.dart';

class ThemeState {
  final ThemeModel theme;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final String font;
  final DarkOption darkOption;
  final double? textScaleFactor;

  ThemeState({
    required this.theme,
    required this.lightTheme,
    required this.darkTheme,
    required this.font,
    this.textScaleFactor,
    required this.darkOption,
  });

  factory ThemeState.fromDefault() {
    return ThemeState(
      theme: AppTheme.defaultTheme,
      lightTheme: AppTheme.getTheme(
        theme: AppTheme.defaultTheme,
        brightness: Brightness.light,
        font: AppTheme.defaultFont,
      ),
      darkTheme: AppTheme.getTheme(
        theme: AppTheme.defaultTheme,
        brightness: Brightness.dark,
        font: AppTheme.defaultFont,
      ),
      font: AppTheme.defaultFont,
      darkOption: AppTheme.darkThemeOption,
    );
  }
}

abstract class ApplicationState {}

class ApplicationStateLoading extends ApplicationState {}

class ApplicationStateSuccess extends ApplicationState {
  final Locale language;
  final ThemeState theme;

  ApplicationStateSuccess({
    required this.language,
    required this.theme,
  });
}

class ApplicationStateFailure extends ApplicationState {
  final String error;
  ApplicationStateFailure({required this.error});
}
