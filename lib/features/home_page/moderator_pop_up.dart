import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/theme/theme.dart';

class ModeratorPopUP extends StatelessWidget {
  final PostModel postModel;
  const ModeratorPopUP({
    required this.postModel, 
    super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: SingleChildScrollView(
      child: Column( 
        children: [
          ArrowButton(
                onPressed: () {}, // Replace print('Moderator') with an empty function.
              buttonText: "Approve post",
              buttonIcon: Icons.check,
              hasarrow: false
              ),
          ArrowButton(
              onPressed: () {},
              buttonText: "Remove post",
              buttonIcon: Icons.remove_circle_outline,
              hasarrow: false),
          ArrowButton(
              onPressed: () {},
              buttonText: "Remove as spam",
              buttonIcon: Icons.remove_from_queue_outlined,
              hasarrow: false),
          ArrowButton(
              onPressed: () {},
              buttonText: "Lock comments",
              buttonIcon: Icons.lock_outline,
              hasarrow: false),
          ArrowButton(
            onPressed: () {}, 
            buttonText: "Sticky post", 
            buttonIcon: Icons.push_pin_outlined,
            hasarrow: false),
          ArrowButton(
              onPressed: () {},
              buttonText: "Mark as spoiler",
              buttonIcon: Icons.warning_amber_outlined,
              hasarrow: false),
          ArrowButton( 
              onPressed: () {},
              buttonText: "Mark as NSFW",
              buttonIcon: Icons.eighteen_up_rating_outlined,
              hasarrow: false),
          ArrowButton(
            onPressed: () {}, 
            buttonText: "Adjust Croud Control", 
            buttonIcon: Icons.group_outlined,
            hasarrow: false),
          
        ],
      ),
    ),
    );
  }
}
