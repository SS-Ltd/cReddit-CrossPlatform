import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/User/follow_unfollow_button.dart';

void main() {
  // Helper function to create a testable widget
  Widget createTestableWidget(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('FollowButton Tests', () {
    testWidgets('FollowButton initializes as not following',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(FollowButton(
        userName: 'user123',
        profileName: 'JohnDoe',
      )));

      // Check the initial state and text of the button
      final followButton = find.byType(ElevatedButton);
      expect(followButton, findsOneWidget);
      expect(find.text('Follow'), findsOneWidget);
    });

    // testWidgets('FollowButton shows loading indicator when processing',
    //     (WidgetTester tester) async {
    //   await tester.pumpWidget(createTestableWidget(FollowButton(
    //     userName: 'user123',
    //     profileName: 'JohnDoe',
    //   )));

    //   // Tap the follow button
    //   await tester.tap(find.byType(ElevatedButton));
    //   await tester.pump(); // Start the loading state

    //   // Check if the loading indicator is shown
    //   expect(find.byType(SpinKitCircle), findsOneWidget);
    // });

    testWidgets('FollowButton toggles follow state upon tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(FollowButton(
        userName: 'user123',
        profileName: 'JohnDoe',
      )));

      // Tap the follow button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(
          Duration(seconds: 1)); // Wait for the Future.delayed to complete

      // Expect the button to show '✓ Following' after a tap
      expect(find.text('✓ Following'), findsOneWidget);

      // Tap the button again to unfollow
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(
          Duration(seconds: 1)); // Wait for the Future.delayed to complete

      // Expect the button to show 'Follow' after another tap
      expect(find.text('Follow'), findsOneWidget);
    });

    testWidgets('FollowButton shows snackbar on follow/unfollow',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(FollowButton(
        userName: 'user123',
        profileName: 'JohnDoe',
      )));

      // Tap the follow button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(
          const Duration(seconds: 2)); // Wait for snackbar to show

      // Expect to see the snackbar
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Following user!'), findsOneWidget);

      // Tap the button again to unfollow
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle(
          const Duration(seconds: 2)); // Wait for snackbar to show

      // Expect to see the unfollow snackbar
      expect(
          find.text('You are no longer following this user.'), findsOneWidget);
    });
  });
}
