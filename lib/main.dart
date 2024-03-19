import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/logger.dart';
import 'package:reddit_clone/features/home_page/widgets/custom_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Logger.getLogger().d('MyApp build');
    return const MaterialApp(
        title: 'Flutter Demo', home: CustomNavigationBar());
  }
}
