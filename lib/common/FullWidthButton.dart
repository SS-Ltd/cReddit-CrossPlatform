import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

class FullWidthButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  FullWidthButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Palette.redditLightGrey),
        child: Text(text,
            style: const TextStyle(
                fontSize: 20,
                color: Palette.redditDarkGrey,
                fontWeight: FontWeight.bold)));
  }
}
