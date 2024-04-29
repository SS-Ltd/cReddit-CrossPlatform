import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/arrow_button.dart';

class ModeratorPopUP extends StatelessWidget {
  const ModeratorPopUP({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Column(
        children: [
          ArrowButton(
                onPressed: () {}, // Replace print('Moderator') with an empty function.
              buttonText: "Approve post",
              buttonIcon: Icons.check),
          ArrowButton(
              onPressed: () {},
              buttonText: "Remove post",
              buttonIcon: Icons.remove_circle_outline),
          ArrowButton(
              onPressed: () {},
              buttonText: "Remove as spam",
              buttonIcon: Icons.remove_from_queue_outlined),
          ArrowButton(
              onPressed: () {},
              buttonText: "Lock comments",
              buttonIcon: Icons.lock_outline),
          ArrowButton(
            onPressed: () {}, 
            buttonText: "Sticky post", 
            buttonIcon: Icons.push_pin_outlined),
          ArrowButton(
              onPressed: () {},
              buttonText: "Mark as spoiler",
              buttonIcon: Icons.warning_amber_outlined),
          ArrowButton( 
              onPressed: () {},
              buttonText: "Mark as NSFW",
              buttonIcon: Icons.eighteen_up_rating_outlined),
          ArrowButton(
            onPressed: () {}, 
            buttonText: "Adjust Croud Control", 
            buttonIcon: Icons.group_outlined),
          
        ],
      ),
    );
  }
}
