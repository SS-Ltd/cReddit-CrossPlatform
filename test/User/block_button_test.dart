import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/User/block_button.dart';

void main() {
  group('BlockButton Tests', () {
    testWidgets('Renders circular button correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlockButton(
            isCircular: true,
            onPressed: () {},
          ),
        ),
      ));

      expect(find.byType(IconButton), findsNothing);
    });

    testWidgets('Button press calls onPressed callback',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: BlockButton(
            isCircular: false,
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, true);
    });
  });

  group('BlockConfirmationDialog Tests', () {
    testWidgets('Displays dialog content and responds to buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ElevatedButton(
            onPressed: () {
              showDialog(
                context: tester.element(find.byType(ElevatedButton)),
                builder: (context) => const BlockConfirmationDialog(),
              );
            },
            child: const Text('Show Dialog'),
          ),
        ),
      ));

      // Open the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pump(); // Pump to show dialog

      // Check for text and buttons
      expect(find.text('Are you Sure?'), findsOneWidget);
      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('BLOCK'), findsOneWidget);

      // Tap BLOCK and check for snackbar
      await tester.tap(find.text('BLOCK'));
      await tester
          .pumpAndSettle(); // May need to pump more than once depending on snackbar timing
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });

  group('SlideInSnackBar Tests', () {
    testWidgets('Displays and animates correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SlideInSnackBar(
            content: 'Test Snackbar',
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.black,
            textColor: Colors.white,
          ),
        ),
      ));

      // Initial state before animation starts
      expect(find.text('Test Snackbar'), findsOneWidget);
      // Verify if animation controller starts the slide animation
      // You may need to pump with a time duration and verify positions or opacity changes
    });
  });
}
