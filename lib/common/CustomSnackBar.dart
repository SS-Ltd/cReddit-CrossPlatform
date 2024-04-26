import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
class CustomSnackBar {
  final BuildContext context;
  final String content;
  final Color textColor;
  final Color backgroundColor;

  CustomSnackBar({
    required this.context, 
    required this.content, 
    this.textColor = Palette.whiteColor,
    this.backgroundColor = Palette.blackColor,
  });

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: TextStyle(color: textColor),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}