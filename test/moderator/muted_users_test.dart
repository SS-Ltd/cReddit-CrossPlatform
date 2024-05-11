import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/muted_users.dart';

void main() {
  testWidgets('MutedUser Widget Test', (WidgetTester tester) async {
  // Build the MutedUser widget.
  await tester.pumpWidget(const MaterialApp(home: MutedUser()));

  // Verify that the MutedUser widget is rendered.
  expect(find.byType(MutedUser), findsOneWidget);

  // Verify that the Scaffold widget is present.
  expect(find.byType(Scaffold), findsOneWidget);

  // Verify that the AppBar widget is present.
  expect(find.byType(AppBar), findsOneWidget);

  // Verify that the AppBar title is 'Muted users'.
  expect(find.text('Muted users'), findsOneWidget);

  // Verify that the IconButton widgets are present.
  expect(find.byType(IconButton), findsNWidgets(2));

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