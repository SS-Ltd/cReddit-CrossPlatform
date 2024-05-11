import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/comments/reply_comment.dart';

void main() {
  testWidgets('ReplyPage Widget Test', (WidgetTester tester) async {
    // Build the ReplyPage widget
    await tester.pumpWidget(MaterialApp(
      home: ReplyPage(
        commentContent: 'Test Comment',
        username: 'Test User',
        timestamp: DateTime.now(),
      ),
    ));

    // Verify that the ReplyPage is displayed
    expect(find.text('Reply'), findsOneWidget);
    expect(find.text('Test Comment'), findsOneWidget);
    expect(find.text('Test User'), findsOneWidget);

    // Verify that the text field is initially empty
    expect(find.widgetWithText(TextFormField, ''), findsOneWidget);

    // Simulate entering text into the text field
    await tester.enterText(find.byType(TextFormField), 'Test Reply');
    await tester.pump();

    // Verify that the entered text is displayed in the text field
    expect(find.widgetWithText(TextFormField, 'Test Reply'), findsOneWidget);

    // Simulate tapping the "Post" button
    await tester.tap(find.widgetWithText(TextButton, 'Post'));
    await tester.pump();

    // Since the image is not selected, the snackbar should be displayed
    expect(find.text('Please enter a message'), findsNothing);

    // Clear the text field
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();

    // Simulate tapping the "Post" button with empty text field
    await tester.tap(find.widgetWithText(TextButton, 'Post'));
    await tester.pump();
    
    // Simulate tapping the "Close" button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump();

        // Simulate tapping the "Insert Photo" button
    await tester.tap(find.byIcon(Icons.insert_photo_outlined));
    await tester.pump();
  });
}