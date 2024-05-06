import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/theme.dart';
import 'package:reddit_clone/services/google_service.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
import 'services/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'default_channel', // id
  'Default Channel', // title
  importance: Importance.high,
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isAndroid) {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );


    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the token for this device
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print('Firebase Messaging Token: $fcmToken');

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      // Save new token if necessary
    }).onError((err) {
      // Handle any errors
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        // Create a local notification
        const AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails('default_channel', 'Default Channel',
                importance: Importance.max,
                priority: Priority.high,
                showWhen: false);
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        flutterLocalNotificationsPlugin.show(0, message.notification!.title,
            message.notification!.body, platformChannelSpecifics,
            payload: 'item x');

        // Navigate to CustomNavigationBar when the notification is tapped
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse response) async {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => CustomNavigationBar(
                      isProfile: false, navigateToChat: true)),
            );
          },
        );
      }
    });
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NetworkService()),
        ChangeNotifierProvider(create: (context) => GoogleService()),
        ChangeNotifierProvider(
            create: (context) =>
                MenuState()) // Add GoogleSignInService provider
      ],
      child: MyApp(fcmToken: fcmToken),
    ));
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final String? fcmToken;
  const MyApp({super.key, this.fcmToken});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    //if (message.data['type'] == 'chat') {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
            builder: (context) =>
                CustomNavigationBar(isProfile: false, navigateToChat: true)),
      );
    });
    // }
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'cReddit',
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: PageView(
          children: [
            LoginScreen(fcmToken: widget.fcmToken),
            SignUpScreen(fcmToken: widget.fcmToken),
          ],
        ),
      ),
    );
  }
}
