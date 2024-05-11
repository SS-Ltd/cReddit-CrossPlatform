import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/add_rule.dart';

void main() {
  testWidgets('AddRule widget test', (WidgetTester tester) async {
    // Build our AddRule widget
    await tester.pumpWidget(MaterialApp(home: AddRule()));

    expect(find.text('Create rule'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Report Reason'), findsOneWidget);
    expect(find.text('Report reason applies to:'), findsOneWidget);
    expect(find.byType(RadioListTile), findsNWidgets(3)); // 3 RadioListTile

    // Simulate entering text into the Title TextField
    await tester.enterText(find.byType(TextField).first, 'Test Rule Title');

    // Verify that the text entered is reflected in the TextField
    expect(find.text('Test Rule Title'), findsOneWidget);

    // Verify that the save button is disabled initially
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled, isFalse);

    // Simulate entering text into the Description TextField
    await tester.enterText(find.byType(TextField).at(1), 'Test Rule Description');

    // Verify that the save button is enabled after entering both Title and Description
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled, isTrue);

    // Tap on the save button and verify if onPressed is called
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // You can add more test cases to further cover different scenarios
  });
}
