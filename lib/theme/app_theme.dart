import 'package:flutter/material.dart';
import 'palette.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundColor,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.appBar,
      elevation: 0,
      iconTheme: IconThemeData(color: Palette.whiteColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.appBar,
      selectedItemColor: Palette.whiteColor,
      unselectedItemColor: Palette.whiteColor,
    ),
    textTheme: const TextTheme(
      labelSmall: TextStyle(
        color: Palette.whiteColor,
        fontSize: 11,
      ),
      labelMedium: TextStyle(
        color: Palette.whiteColor,
        fontSize: 14,
      ),
  ));
}

