import 'package:flutter/material.dart';
import 'package:reddit_clone/common/logger.dart';
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
    Logger.getLogger().d('MyApp build');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.redditBackground),
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
