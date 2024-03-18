import 'package:flutter/material.dart';
import 'package:reddit_clone/comment_page.dart';
import 'home.dart';
import 'user_comment.dart';
import 'theme/app_theme.dart';
void main() {
  runApp(MaterialApp(
    theme: AppTheme.theme,
    initialRoute: '/commentpage',
    routes: {
      '/comment': (context) => UserComment(username: 'test', content: 'This is a comment from User123', timestamp: DateTime.now()),
      '/home': (context) => const Home(),
      '/commentpage':(context) => const CommentPage(),
      },
  ));
}
