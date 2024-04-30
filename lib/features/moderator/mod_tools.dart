import 'package:flutter/material.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/features/moderator/approved_user.dart';
import 'package:reddit_clone/features/moderator/banned_users.dart';
import 'package:reddit_clone/features/moderator/description.dart';
import 'package:reddit_clone/features/moderator/location.dart';
import 'package:reddit_clone/features/moderator/moderators.dart';
import 'package:reddit_clone/features/moderator/muted_users.dart';

class ModeratorTools extends StatefulWidget {
  const ModeratorTools({super.key});

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
                onPressed: () {},
                buttonText: "Mod log",
                buttonIcon: Icons.list),
            ArrowButton(
                onPressed: () {},
                buttonText: "Insights",
                buttonIcon: Icons.query_stats),
            ArrowButton(
                onPressed: () {},
                buttonText: "Community icon",
                buttonIcon: Icons.reddit),
            ArrowButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Description()));
                },
                buttonText: "Description",
                buttonIcon: Icons.description),
            ArrowButton(
                onPressed: () {},
                buttonText: "Welcome message",
                buttonIcon: Icons.message),
            ArrowButton(
                onPressed: () {},
                buttonText: "Topics",
                buttonIcon: Icons.topic),
            ArrowButton(
                onPressed: () {},
                buttonText: "Community type",
                buttonIcon: Icons.lock),
            ArrowButton(
                onPressed: () {},
                buttonText: "Post type",
                buttonIcon: Icons.type_specimen),
            ArrowButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Location()));
                },
                buttonText: "Location",
                buttonIcon: Icons.location_on_outlined),
            const Heading(text: "USER MANAGEMENT"),
            ArrowButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Moderator()));
                },
                buttonText: "Moderators",
                buttonIcon: Icons.shield_outlined),
            ArrowButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ApprovedUser()));
                },
                buttonText: "Approved users",
                buttonIcon: Icons.person_2_outlined),
            ArrowButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MutedUser()));
                },
                buttonText: "Muted users",
                buttonIcon: Icons.block_flipped),
            ArrowButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BannedUser()));
                },
                buttonText: "Banned users",
                buttonIcon: Icons.handyman_outlined),
          ],
        ),
      ),
    );
  }
}
