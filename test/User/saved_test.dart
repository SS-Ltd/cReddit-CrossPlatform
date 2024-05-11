import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/User/saved.dart';
import 'package:reddit_clone/features/chat/chat_list.dart';
import 'package:reddit_clone/features/comments/saved_comments.dart';
import 'package:reddit_clone/features/post/saved_posts.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('SavedPage Tests', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: const SavedPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Posts'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);
    expect(find.byType(SavedPosts), findsOneWidget);
    expect(find.byType(SavedComments), findsNothing);
  });

  testWidgets('switching to "Comments" tab shows comments',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: const SavedPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap on the "Comments" tab
    await tester.tap(find.text('Comments'));
    await tester.pumpAndSettle();

    // Verify that "Comments" content is now displayed
    expect(find.byType(SavedComments), findsOneWidget);
    expect(find.byType(SavedPosts), findsNothing);
  });
}
