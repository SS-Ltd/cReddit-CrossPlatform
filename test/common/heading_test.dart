import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/heading.dart';
import 'package:reddit_clone/theme/palette.dart';

void main() {
  testWidgets('Heading widget test', (WidgetTester tester) async {
    // Define a value for the heading text
    final headingText = 'Test Heading';

    // Build the Heading widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Heading(text: headingText),
      ),
    ));

    // Verify the heading text is present
    expect(find.text(headingText), findsOneWidget);

    // Verify the heading text color
    final Text headingWidget = tester.widget(find.text(headingText));
    expect(headingWidget.style?.color, equals(Palette.whiteColor));
  });
}
