import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
class CustomSnackBar {
  final BuildContext context;
  final String content;

  CustomSnackBar({required this.context, required this.content});

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      content,
      style: const TextStyle(color: Palette.whiteColor),
    ),
    duration: const Duration(seconds: 3),
    backgroundColor: Palette.blackColor, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    behavior: SnackBarBehavior.floating,
  ),
);
  }
}