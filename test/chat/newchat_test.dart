import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/chat/chat_screen.dart';
import 'package:reddit_clone/features/chat/newchat.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('newChatPage builds and shows messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: NewChatPage(),
        ),
      ),
    );

    // Pump to settle the asynchronous operations
    await tester.pumpAndSettle();

    // Check if the ChatScreen shows the expected messages and elements
    // Verify the presence of search field and initial UI elements
    expect(find.text('New Chat'), findsOneWidget);
    expect(find.text('Search for people by username to chat with them.'),
        findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Create'), findsOneWidget); // Disabled initially
    await tester.enterText(find.byType(TextField), 'user1');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Simulate tapping on the user
// Simulate tapping on the user
    await tester.tap(find.widgetWithText(ListTile, 'user1'));
    await tester.pump();
  });

  testWidgets('Handles creating single or group chats based on selection',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: NewChatPage(),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'user');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    await tester.tap(find.text('user1'));
    await tester.tap(find.text('user2'));
    await tester.pumpAndSettle();
  });
}
