import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final String iconPath;

  ImageButton(
      {required this.text, required this.onPressed, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Row(
        children: [
          SvgPicture.asset(iconPath, width: 30),
          SizedBox(width: 20), // Add some spacing between icon and text
        ],
      ),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: Palette.redditBlack,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Palette.redditLightGrey,
      ),
    );
  }
}
