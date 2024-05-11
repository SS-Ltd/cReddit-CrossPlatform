import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/User/chat_button.dart';

void main() {
  testWidgets('ChatButton widget test', (WidgetTester tester) async {
    // Define a value for the userName and profileName
    final userName = 'Test User';
    final profileName = 'Test Profile';

    // Build the ChatButton widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ChatButton(userName: userName, profileName: profileName),
      ),
    ));

    // Verify the chat button is present
    expect(find.byType(ChatButton), findsOneWidget);

    // Verify the chat button icon is present
    expect(find.byIcon(Icons.chat), findsOneWidget);
  });
}
