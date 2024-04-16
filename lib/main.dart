import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/services/google_service.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NetworkService()),
      ChangeNotifierProvider(create: (context) => GoogleService()),
      ChangeNotifierProvider(
          create: (context) => MenuState()) // Add GoogleSignInService provider
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cReddit',
      theme: AppTheme.darkTheme,
      //home: LoginScreen(),
      home: Scaffold(
        body: PageView(
          children: <Widget>[
            const LoginScreen(),
            SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
