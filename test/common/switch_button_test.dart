import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/common/switch_button.dart';

void main() {
  group('SwitchButton tests', () {
    testWidgets('SwitchButton changes value when pressed',
        (WidgetTester tester) async {
      bool switchValue = false;

      // Build the SwitchButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchButton(
              buttonText: 'Test',
              onPressed: (value) {
                switchValue = value;
              },
              switchvalue: switchValue,
            ),
          ),
        ),
      );

      // Find the Switch widget
      final switchFinder = find.byType(Switch);

      // Tap on the Switch widget
      await tester.tap(switchFinder);

      // Rebuild the widget after the state change
      await tester.pump();

      // Expect the switchValue to be true
      expect(switchValue, true);
    });

    testWidgets('SwitchButton changes value to false when pressed',
        (WidgetTester tester) async {
      bool switchValue = true;

      // Build the SwitchButton widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SwitchButton(
              buttonText: 'Test',
              onPressed: (value) {
                switchValue = value;
              },
              switchvalue: switchValue,
            ),
          ),
        ),
      );

      // Find the Switch widget
      final switchFinder = find.byType(Switch);

      // Tap on the Switch widget
      await tester.tap(switchFinder);

      // Rebuild the widget after the state change
      await tester.pump();

      // Expect the switchValue to be false
      expect(switchValue, false);
    });
  });
}
