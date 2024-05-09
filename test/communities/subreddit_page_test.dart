import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Subreddit Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: SubRedditPage(
            subredditName: 'test',
          ),
        ),
      ),
    );

    // Verify that a loading indicator is shown initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Pump the widget tree to allow the Future to complete
   await tester.pump();

  // Verify that the post's title and content are displayed on the screen
  expect(find.text('Test Post'), findsOneWidget);
  expect(find.text('Hello there!'), findsOneWidget);

  // Verify that the "Join" button is displayed on the screen
  expect(find.text('Join'), findsOneWidget);
  });
}
