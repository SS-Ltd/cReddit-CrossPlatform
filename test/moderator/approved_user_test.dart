import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/approved_user.dart';

void main() {
  testWidgets('ApprovedUser Widget Test', (WidgetTester tester) async {
  // Build the ApprovedUser widget.
  await tester.pumpWidget(const MaterialApp(home: ApprovedUser()));

  // Verify that the ApprovedUser widget is rendered.
  expect(find.byType(ApprovedUser), findsOneWidget);

  // Verify that the AppBar title is 'Approved users'.
  expect(find.text('Approved users'), findsOneWidget);

  // Verify that the back button is working correctly.
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pump();

  // Verify that the add button is working correctly.
  await tester.tap(find.byIcon(Icons.add));
  await tester.pump();

  // Verify that the ListView is populated correctly.
  expect(find.byType(ListTile), findsWidgets);
  expect(find.byType(Divider), findsWidgets);
  });
}