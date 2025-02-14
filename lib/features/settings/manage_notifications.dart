import 'package:flutter/material.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/common/switch_button.dart';
import 'package:reddit_clone/features/settings/settings.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

class ManageNotifications extends StatefulWidget {
  const ManageNotifications({super.key});

  @override
  State<ManageNotifications> createState() {
    return _ManageNotificationsState();
  }
}

class _ManageNotificationsState extends State<ManageNotifications> {
  bool? mentions;
  bool? comments;
  bool? upvotes;
  bool? replies;
  bool? followers;
  bool? posts;
  bool? cakeday;
  bool? modNotifs;
  bool? moderator;
  bool? invitations;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<NetworkService>().getUserSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final settings = context.read<NetworkService>().userSettings;
          mentions = settings!.notifications.mentionsNotifs;
          comments = settings.notifications.commentsNotifs;
          upvotes = settings.notifications.postsUpvotesNotifs;
          replies = settings.notifications.repliesNotifs;
          followers = settings.notifications.newFollowersNotifs;
          posts = settings.notifications.postNotifs;
          cakeday = settings.notifications.cakeDayNotifs;
          modNotifs = settings.notifications.modNotifs;
          //moderator = settings.notifications.moderatorInCommunities;
          invitations = settings.notifications.invitationNotifs;
          return StatefulBuilder(
            builder: (context, setState) {
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
                          onPressed: (value) async {
                            setState(() {
                              mentions = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'mentionsNotifs', value);
                          },
                          switchvalue: mentions ?? true),
                      SwitchButton(
                          buttonText: "Comments on your posts",
                          buttonicon: Icons.comment,
                          onPressed: (value) async {
                            setState(() {
                              comments = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'commentsNotifs', value);
                          },
                          switchvalue: comments ?? true),
                      SwitchButton(
                          buttonText: "Upvotes on your posts",
                          buttonicon: Icons.arrow_upward,
                          onPressed: (value) async {
                            setState(() {
                              upvotes = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'postsUpvotesNotifs', value);
                          },
                          switchvalue: upvotes ?? true),
                      SwitchButton(
                          buttonText: "Replies to your comments",
                          buttonicon: Icons.reply,
                          onPressed: (value) async {
                            setState(() {
                              replies = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'repliesNotifs', value);
                          },
                          switchvalue: replies ?? true),
                      SwitchButton(
                          buttonText: "New followers",
                          buttonicon: Icons.person_add_alt,
                          onPressed: (value) async {
                            setState(() {
                              followers = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'newFollowersNotifs', value);
                          },
                          switchvalue: followers ?? true),
                      const Heading(text: "UPDATES"),
                      SwitchButton(
                          buttonText: "Cake day",
                          buttonicon: Icons.cake,
                          onPressed: (value) async {
                            setState(() {
                              cakeday = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'cakeDayNotifs', value);
                          },
                          switchvalue: cakeday ?? true),
                      const Heading(text: "MODERATION"),
                      SwitchButton(
                          buttonText: "Mod notifications",
                          buttonicon: Icons.shield,
                          onPressed: (value) async {
                            setState(() {
                              modNotifs = value;
                            });
                            await context
                                .read<NetworkService>()
                                .updateNotificationsSettings(
                                    'modNotifs', value);
                          },
                          switchvalue: modNotifs ?? true),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
