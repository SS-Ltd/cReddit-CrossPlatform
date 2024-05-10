import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/CustomPopupMenuItem.dart';

void main() {
  testWidgets('CustomPopupMenuItem test', (WidgetTester tester) async {
    // Define a value for the menu item
    final menuItemValue = 'Test';

    // Build the CustomPopupMenuItem widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CustomPopupMenuItem<String>(
          child: Text('Test'),
          value: menuItemValue,
        ),
      ),
    ));

    // Verify the menu item text is present
    expect(find.text('Test'), findsOneWidget);

    // Tap the menu item
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();

    // Since the CustomPopupMenuItem uses Navigator.pop on tap,
    // we can't directly test the value it returns.
    // But we can at least verify that tapping the item doesn't result in an exception.
  });
}
