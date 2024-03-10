import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/logger.dart';

class Heading extends StatelessWidget {

  final String text;

  const Heading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [Text(text)],
      ),
    );
  }
}
