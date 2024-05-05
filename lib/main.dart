import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/services/google_service.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
import 'services/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (Platform.isIOS) {
    // Request notification permissions
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);

    // For apple platforms
    // ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      print('APNS Token: $apnsToken');

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
    } else {
      print('APNS token is not available');
    }
  } else {
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
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Save new token if necessary
      print('Token refreshed: $newToken');
    }).onError((err) {
      // Handle any errors
      print('Error refreshing token: $err');
    });
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => NetworkService()),
      ChangeNotifierProvider(create: (context) => GoogleService()),
      ChangeNotifierProvider(
          create: (context) => MenuState()) // Add GoogleSignInService provider
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'cReddit',
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: PageView(
          children: const [
            LoginScreen(),
            SignUpScreen(),
          ],
        ),
      ),
    );
  }
}
