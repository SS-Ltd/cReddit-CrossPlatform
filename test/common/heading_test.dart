import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/Heading.dart';

void main() {
  testWidgets('Heading renders correctly', (WidgetTester tester) async {
    // Build our widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Heading(
            text: 'Test Heading',
          ),
        ),
      ),
    );
    await tester.pump(); // Wait for any animations or async tasks to complete

    // Verify that the Container is rendered
    expect(find.byType(Container), findsOneWidget);

    // Verify that the Row is rendered
    expect(find.byType(Row), findsOneWidget);

    // Verify that the Text is rendered
    expect(find.byType(Text), findsOneWidget);

    // Verify that the text is rendered correctly
    expect(find.text('Test Heading'), findsOneWidget);
  });
}