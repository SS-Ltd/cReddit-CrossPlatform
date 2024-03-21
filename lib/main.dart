import 'package:flutter/material.dart';


import 'package:reddit_clone/common/logger.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.redditBackground),
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
