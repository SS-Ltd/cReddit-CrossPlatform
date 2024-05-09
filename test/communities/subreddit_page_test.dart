import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Community Page', (WidgetTester tester) async {
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
    await tester.pumpAndSettle();
    expect(find.text('Join'), findsOneWidget);
  });
}
