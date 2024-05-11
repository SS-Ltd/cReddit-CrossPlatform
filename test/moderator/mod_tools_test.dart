import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/mod_tools.dart';

void main() {
  testWidgets('Mod Tools widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ModeratorTools(communityName: '',)));

    expect(find.text('Moderator Tools'), findsOneWidget);
    expect(find.text("GENERAL"), findsOneWidget);
    expect(find.text('Mod log'), findsOneWidget);
    expect(find.text('Insights'), findsOneWidget);
    expect(find.text('Community icon'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Welcome message'), findsOneWidget);
    expect(find.text('Topics'), findsOneWidget);
    expect(find.text('Community type'), findsOneWidget);
    expect(find.text('Post type'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('CONTENT & REGULATIONS'), findsOneWidget);
    expect(find.text('Queues'), findsOneWidget);
    expect(find.text('Rules'), findsOneWidget);
    expect(find.text('Scheduled posts'), findsOneWidget);
    expect(find.text('USER MANAGEMENT'), findsOneWidget);
    expect(find.text('Moderators'), findsOneWidget);
    expect(find.text('Approved users'), findsOneWidget);
    expect(find.text('Muted users'), findsOneWidget);
    expect(find.text('Banned users'), findsOneWidget);

    expect(find.byType(IconButton), findsOneWidget);
    

    expect(find.byKey(const Key('mod_log')), findsOneWidget);
    expect(find.byKey(const Key('insights')), findsOneWidget);
    expect(find.byKey(const Key('community_icon')), findsOneWidget);
    expect(find.byKey(const Key('description')), findsOneWidget);
    expect(find.byKey(const Key('welcome_message')), findsOneWidget);
    expect(find.byKey(const Key('topics')), findsOneWidget);
    expect(find.byKey(const Key('community_type')), findsOneWidget);
    expect(find.byKey(const Key('post_type')), findsOneWidget);
    expect(find.byKey(const Key('location')), findsOneWidget);
    expect(find.byKey(const Key('queues')), findsOneWidget);
    expect(find.byKey(const Key('rules')), findsOneWidget);
    expect(find.byKey(const Key('scheduled_posts')), findsOneWidget);
    expect(find.byKey(const Key('moderators')), findsOneWidget);
    expect(find.byKey(const Key('approved_users')), findsOneWidget);
    expect(find.byKey(const Key('muted_users')), findsOneWidget);
    expect(find.byKey(const Key('banned_users')), findsOneWidget);

  });
}
