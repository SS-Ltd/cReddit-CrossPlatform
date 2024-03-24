import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/logger.dart';
import 'package:reddit_clone/report_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create a community',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(1, 1, 1, 1),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(16, 16, 16, 1),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ReportButton(), // Set HomePage as the initial route
    );
  }
}
