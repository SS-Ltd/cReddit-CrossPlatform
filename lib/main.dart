import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/Authentication/reset_password_done.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/community_card.dart';
import 'package:reddit_clone/community_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create a community',
      theme: AppTheme.darkTheme,
      //home: LoginScreen(),
      // home: CommunityCard(
      //   avatarUrl:
      //       'assets/MonkeyDLuffy.png',
      //   title: 'Flutter',
      //   members: 1000,
      //   description:
      //       'A community for Flutter developers to share knowledge and ask questions.',
      // ),

      home: CommunityPage(),
    );
  }
}
