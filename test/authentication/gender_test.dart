import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/Authentication/forget_password.dart';
import 'package:reddit_clone/features/Authentication/gender.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/Authentication/name_suggestion.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Gender widget test', (WidgetTester tester) async {
    // Mock the NetworkService
    final mockNetworkService = MockNetworkService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
              create: (_) => mockNetworkService),
        ],
        child: MaterialApp(
          home: Gender(userData: {
            'username': '',
            'email': '',
            'password': '',
            'gender': ''
          }),
        ),
      ),
    );

    // Verify that the "Continue" button is found.
    expect(find.text('Continue'), findsOneWidget);

    // Tap the 'Continue' button and trigger a frame.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Tap the 'Skip' button and trigger a frame.
    // await tester.tap(find.byKey(Key('skip')));
    // await tester.pump();
  });

  testWidgets('Gender widget test - skip', (WidgetTester tester) async {
    // Mock the NetworkService
    final mockNetworkService = MockNetworkService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
              create: (_) => mockNetworkService),
        ],
        child: MaterialApp(
          home: Gender(userData: {
            'username': '',
            'email': '',
            'password': '',
            'gender': ''
          }),
        ),
      ),
    );

    // Tap the 'Skip' button and trigger a frame.
    await tester.tap(find.byKey(Key('skip')));
    await tester.pump();
  });

  testWidgets('NameSuggestion widget test', (WidgetTester tester) async {
    final mockNetworkService = MockNetworkService();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
              create: (_) => mockNetworkService),
        ],
        child: MaterialApp(
          home: NameSuggestion(
            userData: {
              'username': '',
              'email': '',
              'password': '',
              'gender': ''
            },
          ),
        ),
      ),
    );

    // Verify the screen is rendered
    expect(find.text('Create your username'), findsOneWidget);
    await tester.pump();
  });
}
