import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/selection_button.dart';

void main() {
  testWidgets('SelectionButton displays correct text and icon', (WidgetTester tester) async {
    // Build the SelectionButton widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SelectionButton(
            onPressed: () {},
            buttonText: 'Test Button',
            selectedtext: 'Selected',
            buttonIcon: Icons.home,
            optional: 'Optional',
          ),
        ),
      ),
    );

    // Find the Text widgets
    final buttonTextFinder = find.text('Test Button');
    final selectedTextFinder = find.text('Selected');
    final optionalTextFinder = find.text('Optional');

    // Find the Icon widget
    final iconFinder = find.byIcon(Icons.home);

    // Verify the Text widgets and Icon widget are displayed correctly
    expect(buttonTextFinder, findsOneWidget);
    expect(selectedTextFinder, findsOneWidget);
    expect(optionalTextFinder, findsOneWidget);
    expect(iconFinder, findsOneWidget);
  });
}