import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AppTheme {
  // static ThemeData theme = ThemeData.dark().copyWith(
  //   floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //     backgroundColor: Palette.blueColor,
  //   ),
  // );
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundColor,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      backgroundColor: Palette.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Palette.whiteColor),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.backgroundColor,
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
    ),
  );
}

