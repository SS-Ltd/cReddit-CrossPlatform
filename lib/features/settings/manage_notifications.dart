import 'package:flutter/material.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/common/switch_button.dart';

class ManageNotifications extends StatefulWidget {
  const ManageNotifications({super.key});

  @override
  State<ManageNotifications> createState() {
    return _ManageNotificationsState();
  }
}

class _ManageNotificationsState extends State<ManageNotifications> {
  bool mentions = true;
  bool comments = true;
  bool upvotes = true;
  bool replies = true;
  bool followers = true;
  bool posts = true;
  bool cakeday = true;
  bool mod = true;
  bool moderator = true;
  bool invitations = true;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            const Heading(text: "ACTIVITY"),
            SwitchButton(
                buttonText: "Mentions of u/username",
                buttonicon: Icons.person,
                onPressed: (value) {},
                switchvalue: mentions),
            SwitchButton(
                buttonText: "Comments on your posts",
                buttonicon: Icons.comment,
                onPressed: (value) {},
                switchvalue: comments),
            SwitchButton(
                buttonText: "Upvotes on your posts",
                buttonicon: Icons.arrow_upward,
                onPressed: (value) {},
                switchvalue: upvotes),
            SwitchButton(
                buttonText: "Replies to your comments",
                buttonicon: Icons.reply,
                onPressed: (value) {},
                switchvalue: replies),
            SwitchButton(
                buttonText: "New followers",
                buttonicon: Icons.person,
                onPressed: (value) {},
                switchvalue: followers),
            //posts
            const Heading(text: "UPDATES"),
            SwitchButton(
                buttonText: "Cake day",
                buttonicon: Icons.cake,
                onPressed: (value) {},
                switchvalue: cakeday),
          ],
        ),
      ),
    );
  }
}
