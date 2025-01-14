import 'package:blogapp/src/core/theme/color_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = ColorTheme.borderColor]) => OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(15),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorTheme.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(ColorTheme.gradient2),
      errorBorder: _border(ColorTheme.errorColor),
    ),
    appBarTheme: const AppBarTheme(
        backgroundColor: ColorTheme.backgroundColor, elevation: 0),
  );
}
