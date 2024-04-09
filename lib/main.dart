import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/services/google_service.dart';


void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NetworkService()),
      ChangeNotifierProvider(
          create: (context) =>
              GoogleService()), // Add GoogleSignInService provider
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Create a community',
      theme: AppTheme.darkTheme,
      home: LoginScreen(),
      // home: CommunityCard(
      //   avatarUrl:
      //       'assets/MonkeyDLuffy.png',
      //   title: 'Flutter',
      //   members: 1000,
      //   description:
      //       'A community for Flutter developers to share knowledge and ask questions.',
      // ),

      //home: CommunityPage(),
    );
  }
}
