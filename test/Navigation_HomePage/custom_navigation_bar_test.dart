import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('CustomNavigationBar Widget Test', (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
          ChangeNotifierProvider<MenuState>(
            create: (_) => MenuState(), // Replace with your MenuState instance
          ),
        ],
        child: MaterialApp(
          home: CustomNavigationBar(
            isProfile: false,
            myuser: UserModel(
              username: 'testUser',
              displayName: 'Test User',
              profilePicture: 'assets/test.png',
              banner: 'assets/test_banner.png',
              followers: 100,
              email: 'ss@ss.com',
              cakeDay: DateTime.now(),
              isBlocked: false,
            ),
          ),
        ),
      ),
    );

    // Create the Finders.
    final navBarFinder = find.byType(CustomNavigationBar);

    // Use the `findsOneWidget` matcher provided by flutter_test to verify our widget is present.
    expect(navBarFinder, findsOneWidget);
  });

  testWidgets('CustomNavigationBar Widget Test - click on icons',
      (WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
          ChangeNotifierProvider<MenuState>(
            create: (_) => MenuState(), // Replace with your MenuState instance
          ),
        ],
        child: MaterialApp(
          home: CustomNavigationBar(
            isProfile: false,
            myuser: UserModel(
              username: 'testUser',
              displayName: 'Test User',
              profilePicture: 'assets/test.png',
              banner: 'assets/test_banner.png',
              followers: 100,
              email: 'ss@ss.com',
              cakeDay: DateTime.now(),
              isBlocked: false,
            ),
          ),
        ),
      ),
    );

    // Create the Finders.
    final navBarFinder = find.byType(CustomNavigationBar);
    //find by text "communities" and tab on
    // Create the Finder.
    final communityFinder = find.byWidgetPredicate(
      (Widget widget) =>
          widget is BottomNavigationBarItem &&
          (widget as BottomNavigationBarItem).label == 'Communities',
    );

// Tap the 'Communities' BottomNavigationBarItem.
    // await tester.tap(communityFinder);
    // await tester.pumpAndSettle();
    // Use the `findsOneWidget` matcher provided by flutter_test to verify our widget is present.
    expect(navBarFinder, findsOneWidget);
  });
}
