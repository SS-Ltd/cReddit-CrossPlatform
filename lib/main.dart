import 'package:flutter/material.dart';
import 'package:reddit_clone/account_settings.dart';
import 'package:reddit_clone/constants/logger.dart';
import 'package:reddit_clone/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This w idget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Logger.getLogger().d('MyApp build');
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Settings(),
    );
  }
}

