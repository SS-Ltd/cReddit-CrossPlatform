import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/services/google_service.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:reddit_clone/features/Inbox/new_message.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Request notification permissions
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);

  // For apple platforms
  // ensure the APNS token is available before making any FCM plugin API calls
  final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  if (apnsToken != null) {
    // APNS token is available, make FCM plugin API requests...
    print('APNS Token: $apnsToken');
  }

  // Get the token for this device
  String? token = await FirebaseMessaging.instance.getToken();
  print('Firebase Messaging Token: $token');

  // Listen for token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    // Save new token if necessary
    print('Token refreshed: $newToken');
  }).onError((err) {
    // Handle any errors
    print('Error refreshing token: $err');
  });

  /*erGc-ukqRWCfdKkGDsN9Gw:APA91bHOxUdPTEc-xxvHWYb9wbqu7kZptm6QbC27B7_yUHTvCnRl0aNp8m0IzxD2oXdxM3DJAqrDWnu_K8hOXiXbjxdgHjiy7yaPT7DB1WovE7k7YCwqeFcMm2ifqCmRISqvs9iOtJ-u */
  /*cn-qARCcT3evjZeSM-Swdv:APA91bE-n10FJBae7FJEGvIdb5d5p_TdndGmzCiBw8ELSiR-nnht8qq9CbpKUxjF_WnFvyJP_lxOVJJd_LYXi-QsqJgdsyGUftcA9bditrnCNuFQ7XRfHII1Fcjwr5zJmCMVkTOfL_7D */

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
      home: Scaffold(
        body: PageView(
          children: <Widget>[
            const LoginScreen(),
            SignUpScreen(),
          ],
        ),
      ),
      //home: const NewMessage(),
    );
  }
}
