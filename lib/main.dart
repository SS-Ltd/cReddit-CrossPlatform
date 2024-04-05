import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/Authentication/reset_password_done.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/community_card.dart';

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
      home: CommunityCard(
        avatarUrl:
            'https://www.google.com/imgres?q=reddit%20community%20avatar&imgurl=https%3A%2F%2Fstyles.redditmedia.com%2Ft5_6wm3u3%2Fstyles%2FcommunityIcon_oy5c6wovb7ac1.png&imgrefurl=https%3A%2F%2Fwww.reddit.com%2Fr%2Favatartrading%2Fcomments%2F16jxy2w%2Fis_it_possible_to_make_a_community_avatar%2F&docid=bD1eJRKvxK7lGM&tbnid=TT-upF0af7rAOM&vet=12ahUKEwj_oPODo6uFAxUz8LsIHRUtAkEQM3oECFEQAA..i&w=5000&h=5000&hcb=2&itg=1&ved=2ahUKEwj_oPODo6uFAxUz8LsIHRUtAkEQM3oECFEQAA',
        title: 'Flutter',
        members: 1000,
        description:
            'A community for Flutter developers to share knowledge and ask questions.',
      ),

      //home: CommentPage(),
    );
  }
}
