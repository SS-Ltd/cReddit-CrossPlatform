import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/location.dart';

void main() {
  testWidgets('Location widget test', (WidgetTester tester) async {
    // Build our Location widget
    await tester.pumpWidget(const MaterialApp(home: Location()));

    // Verify initial state
    expect(find.text('Location'), findsOneWidget);
    expect(find.text("Adding a location helps your community show up in search results and recommendations and helps local redditors find it easier."), findsOneWidget);
    expect(find.text('Region'), findsOneWidget);
    expect(find.text('City, state or zip code'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(TextEditingController), findsOneWidget);

    // Simulate entering text into the TextField
    await tester.enterText(find.byType(TextField), 'New York');

    // Verify that the text entered is reflected in the TextField
    expect(find.text('New York'), findsOneWidget);

    // Verify that the save button is enabled after entering text
    expect(find.byType(ElevatedButton).first, findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton).first).enabled, isTrue);

    // Tap on the save button and verify if onPressed is called
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle(); // Wait for animations to complete

    // You can add more test cases to further cover different scenarios
  });
}
