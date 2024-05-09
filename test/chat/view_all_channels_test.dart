import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/chat/view_all_channels.dart';

final List<Map<String, dynamic>> mockChannels = [
  {
    'profilePic': 'assets/hehe.png',
    'name': 'Test Channel 1',
    'subredditName': 'Test Subreddit 1',
    'description': 'Test Description 1',
  },
  {
    'profilePic': 'assets/hehe.png',
    'name': 'Test Channel 2',
    'subredditName': 'Test Subreddit 2',
    'description': 'Test Description 2',
  },
];
void main() {
  testWidgets('ViewAllChannels has a title', (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: ViewAllChannels(channels: mockChannels)));

    expect(find.text('Discover Channels'), findsOneWidget);
  });

  testWidgets('ViewAllChannels builds a list of channels',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: ViewAllChannels(channels: mockChannels)));

    expect(find.byType(Card), findsNWidgets(mockChannels.length));
  });

  testWidgets('ViewAllChannels shows the correct channel data',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(MaterialApp(home: ViewAllChannels(channels: mockChannels)));

    for (var channel in mockChannels) {
      expect(find.text(channel['name']), findsOneWidget);
      expect(find.text(channel['subredditName']), findsOneWidget);
      expect(find.text(channel['description']), findsOneWidget);
    }
  });
}
