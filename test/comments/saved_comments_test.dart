import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/comments/saved_comments.dart';
import 'package:reddit_clone/features/comments/user_comment.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ChatListScreen displays mocked data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: SavedComments(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle(); // Wait for async fetch to complete
    expect(find.byType(UserComment), findsNWidgets(1));
  });
}
