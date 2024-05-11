import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/post/community_choice.dart';

void main() {
  testWidgets('CommunityChoice widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CommunityChoice()));

    expect(find.text('Post to'), findsOneWidget);
  });
}