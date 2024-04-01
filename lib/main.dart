import 'package:flutter/material.dart';
import 'package:reddit_clone/comment_page.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/theme/theme.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create a community',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Palette.redditBackground),
      //   dividerTheme: const DividerThemeData(
      //     color: Colors.transparent,
      //   ),
      //   useMaterial3: true,
      // ),
      theme: ThemeData.dark(),
      // home: LoginScreen(),
      home: const CommentPage(),
    );
  }
}
