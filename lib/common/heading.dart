import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cReddit/theme/palette.dart';

class Heading extends StatelessWidget {
  final String text;

  const Heading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Palette.settingsHeading,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(color: Palette.whiteColor),
            ),
          ],
        ),
      ),
    );
  }
}
