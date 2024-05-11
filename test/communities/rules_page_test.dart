import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/community/rules_page.dart';

void main() {
  group('RulesPage Tests', () {
    final testRules = ['No spam', 'Be respectful', 'No personal information'];
    final testModerators = ['mod1', 'mod2', 'mod3'];
    final testDescription = 'This is a subreddit for testing.';
    final testSubredditName = 'TestSubreddit';
    final testBannerURL = 'assets/hehe.png';

    testWidgets('Displays all elements correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: RulesPage(
          rules: testRules,
          description: testDescription,
          subredditName: testSubredditName,
          bannerURL: testBannerURL,
          moderators: testModerators,
        ),
      ));

      // Verify the AppBar title
      expect(find.text('r/$testSubredditName'), findsOneWidget);

      // Verify the description and rules are displayed
      expect(find.text('Description'), findsOneWidget);
      expect(find.text(testDescription), findsOneWidget);
      expect(find.text('Subreddit Rules'), findsOneWidget);
      for (var i = 0; i < testRules.length; i++) {
        var rule = testRules[i];
        expect(find.text('${i + 1}. $rule'), findsOneWidget);
      }

      // Verify the number of rules displayed matches the input
      expect(find.byType(ListView),
          findsNWidgets(3)); // Two ListViews: one for rules, one for moderators
      expect(find.text('Moderators'), findsOneWidget);
      for (var i = 0; i < testModerators.length; i++) {
        var moderator = testModerators[i];
        expect(find.text('${i + 1}. $moderator'), findsOneWidget);
      }
    });

    // Additional tests can be written for interaction, such as scrolling and tapping
  });
}
