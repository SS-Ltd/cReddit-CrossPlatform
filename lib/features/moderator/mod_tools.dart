import 'package:flutter/material.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/features/moderator/approved_user.dart';
import 'package:reddit_clone/features/moderator/banned_users.dart';
import 'package:reddit_clone/features/moderator/community_type.dart';
import 'package:reddit_clone/features/moderator/description.dart';
import 'package:reddit_clone/features/moderator/location.dart';
import 'package:reddit_clone/features/moderator/moderators.dart';
import 'package:reddit_clone/features/moderator/muted_users.dart';
import 'package:reddit_clone/features/moderator/post_types.dart';
import 'package:reddit_clone/features/moderator/queues.dart';
import 'package:reddit_clone/features/moderator/rules.dart';
import 'package:reddit_clone/features/moderator/schedule_posts.dart';

class ModeratorTools extends StatefulWidget {
  const ModeratorTools({super.key, required this.communityName});

  final String communityName;

  @override
  State<ModeratorTools> createState() {
    return _ModeratorToolsSatet();
  }
}

class _ModeratorToolsSatet extends State<ModeratorTools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Moderator Tools'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Heading(text: 'GENERAL'),
            ArrowButton(
              key: const Key('mod_log'),
                onPressed: () {},
                buttonText: "Mod log",
                buttonIcon: Icons.list),
            ArrowButton(
              key: const Key('insights'),
                onPressed: () {},
                buttonText: "Insights",
                buttonIcon: Icons.query_stats),
            ArrowButton(
              key: const Key('community_icon'),
                onPressed: () {},
                buttonText: "Community icon",
                buttonIcon: Icons.reddit),
            ArrowButton(
              key: const Key('description'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Description()));
                },
                buttonText: "Description",
                buttonIcon: Icons.description),
            ArrowButton(
              key: const Key('welcome_message'),
                onPressed: () {},
                buttonText: "Welcome message",
                buttonIcon: Icons.message),
            ArrowButton(
              key: const Key('topics'),
                onPressed: () {},
                buttonText: "Topics",
                buttonIcon: Icons.topic),
            ArrowButton(
              key: const Key('community_type'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CommunityType()));
                },
                buttonText: "Community type",
                buttonIcon: Icons.lock),
            ArrowButton(
              key: const Key('post_type'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostTypes()));
                },
                buttonText: "Post type",
                buttonIcon: Icons.type_specimen),
            ArrowButton(
              key: const Key('location'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Location()));
                },
                buttonText: "Location",
                buttonIcon: Icons.location_on_outlined),
            const Heading(text: "CONTENT & REGULATIONS"),
            ArrowButton(
              key: const Key('queues'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Queues()));
                },
                buttonText: "Queues",
                buttonIcon: Icons.queue),
            ArrowButton(
              key: const Key('rules'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Rules(currentCommunity:  widget.communityName)));
                },
                buttonText: "Rules",
                buttonIcon: Icons.rule_folder),
            ArrowButton(
              key: const Key('scheduled_posts'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SchedulePosts()));
                },
                buttonText: "Scheduled posts",
                buttonIcon: Icons.query_builder),
            const Heading(text: "USER MANAGEMENT"),
            ArrowButton(
              key: const Key('moderators'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Moderator(communityName: widget.communityName,)));
                },
                buttonText: "Moderators",
                buttonIcon: Icons.shield_outlined),
            ArrowButton(
              key: const Key('approved_users'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ApprovedUser()));
                },
                buttonText: "Approved users",
                buttonIcon: Icons.person_2_outlined),
            ArrowButton(
              key: const Key('muted_users'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MutedUser()));
                },
                buttonText: "Muted users",
                buttonIcon: Icons.block_flipped),
            ArrowButton(
              key: const Key('banned_users'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BannedUser(communityName: widget.communityName)));
                },
                buttonText: "Banned users",
                buttonIcon: Icons.handyman_outlined),
          ],
        ),
      ),
    );
  }
}
