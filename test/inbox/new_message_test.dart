import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/Inbox/new_message.dart';

void main() {
  testWidgets('NewMessage widget test', (WidgetTester tester) async {
    // Build the NewMessage widget
    await tester.pumpWidget(const MaterialApp(home: NewMessage()));

    // Verify that the AppBar title is 'New Message'
    expect(find.text('New Message'), findsOneWidget);

    // Verify that the TextButton with the text 'Send' is present
    expect(find.widgetWithText(TextButton, 'Send'), findsOneWidget);

    // Verify that the TextField widgets are present
    expect(find.byType(TextField), findsWidgets);

    expect(find.byType(TextFormField), findsWidgets);


    // Verify that the TextButton widget is disabled initially
    final textButton = tester.widget<TextButton>(find.byType(TextButton));
    expect(textButton.enabled, isFalse);
    
  });
}