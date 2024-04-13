import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cReddit/features/Authentication/login.dart';
import 'package:cReddit/features/home_page/menu_notifier.dart';
import 'package:cReddit/services/networkServices.dart';
import 'package:cReddit/theme/theme.dart';
import 'package:cReddit/services/google_service.dart';

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
      title: 'Create a community',
      theme: AppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}
