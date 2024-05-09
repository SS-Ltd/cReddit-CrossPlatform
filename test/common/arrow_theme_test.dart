import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/common/arrow_button.dart';

void main() {
  testWidgets('ArrowButton displays the correct text',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ArrowButton(
          onPressed: () {},
          buttonText: 'Test Button',
          buttonIcon: Icons.arrow_forward,
        ),
      ),
    ));

    // Verify that our button text is displayed.
    expect(find.text('Test Button'), findsOneWidget);
  });
}
