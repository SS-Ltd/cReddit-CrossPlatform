import 'package:flutter/material.dart';
import 'package:reddit_clone/comment_page.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create a community',
      theme: AppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}


