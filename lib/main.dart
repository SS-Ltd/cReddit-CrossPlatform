import 'package:flutter/material.dart';
import 'home.dart';
import 'user_comment.dart';
import 'theme/app_theme.dart';
void main() {
  runApp(MaterialApp(
    theme: AppTheme.theme,
    initialRoute: '/comment',
    routes: {
      '/comment': (context) => UserComment(username: 'User123', content: 'This is a comment from User123', timestamp: DateTime.now()),
      '/home': (context) => const Home(),
      //'/reply':(context) => const _UserCommentState(),
      },
  ));
}