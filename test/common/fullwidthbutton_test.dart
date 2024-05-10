import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';

void main() {
  testWidgets('FullWidthButton renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FullWidthButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ElevatedButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.byType(Text), findsOneWidget);

    expect(find.text('Test Button'), findsOneWidget);
  });
}