import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/comments/user_comment.dart';
import 'package:reddit_clone/features/moderator/banned_users.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('displays banned users list on data fetch',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: BannedUser(
            communityName: 'TestCommunity',
          ),
        ),
      ),
    );

    expect(find.byType(CustomLoadingIndicator), findsOneWidget);
    await tester.pumpAndSettle(); // Finish the async fetch
    // Check if banned users are displayed correctly
    expect(find.text('u/User1'), findsOneWidget);
    expect(find.text('u/User2'), findsOneWidget);
  });

  testWidgets('navigates to AddBanned on button tap',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: BannedUser(
            communityName: 'TestCommunity',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Finish the async fetch

    await tester.tap(find.byKey(const Key('addButton')));
    await tester.pumpAndSettle(); // Trigger the navigation

    // Verify that AddBanned screen is opened
  });

  testWidgets('navigates back on back button tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: BannedUser(
            communityName: 'TestCommunity',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle(); // Finish the async fetch

    await tester.tap(find.byKey(const Key('backButton')));
    await tester.pumpAndSettle(); // Trigger the navigation

    // Ideally check if the previous screen or desired functionality is achieved
  });
}
