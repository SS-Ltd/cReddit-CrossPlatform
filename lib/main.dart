import 'package:flutter/material.dart';
import 'package:reddit_clone/constants/logger.dart';
import 'package:reddit_clone/create_post.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/Network.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: CreatePost(profile: true,),
    );
  }
}


