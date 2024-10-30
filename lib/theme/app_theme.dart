import 'package:flutter/material.dart';
import 'package:twitter_clone/theme/colors_pallet.dart';

class AppTheme {
  static ThemeData theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: ColorsPallet.backgroundColor,
    appBarTheme: const AppBarTheme(
      color: ColorsPallet.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorsPallet.blueColor),
  );
}
