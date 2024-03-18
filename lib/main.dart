import 'package:flutter/material.dart';
import 'package:reddit_clone/follow_unfollow _button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
          title: Text('Follow Button Test'),
        ),
        body: Center(
          child: FollowButton(),
        ),
      ),
    );
  }
}
