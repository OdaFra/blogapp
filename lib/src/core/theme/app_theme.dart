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
    appBarTheme: const AppBarTheme(
        backgroundColor: ColorTheme.backgroundColor, elevation: 0),
    chipTheme: ChipThemeData(
      color: WidgetStateProperty.all(ColorTheme.backgroundColor),
      side: BorderSide.none,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(ColorTheme.errorColor),
      errorBorder: _border(ColorTheme.errorColor),
    ),
  );
}
