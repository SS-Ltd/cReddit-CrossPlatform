import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/community_type.dart';

void main() {
  testWidgets('CommunityType widget test', (WidgetTester tester) async {
    // Build our CommunityType widget
    await tester.pumpWidget(
      MaterialApp(
        home: CommunityType(),
      ),
    );

    // Verify that the initial state is as expected
    expect(find.text('Public'), findsOneWidget);
    expect(find.text('Anyone can see and participate in this community.'), findsOneWidget);
    expect(find.text('18+ community'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Tap on the Switch widget and verify the state change
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(find.text('Public'), findsOneWidget); 

    // You can write more tests to cover other parts of the widget
  });
}
