import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/chat/chat_screen.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ChatScreen builds and shows messages',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ChatScreen(chatId: '123', usernameOrGroupName: 'Test Group'),
        ),
      ),
    );

    // Pump to settle the asynchronous operations
    await tester.pumpAndSettle();

    // Check if the ChatScreen shows the expected messages and elements
    expect(find.text('Hello there!'), findsOneWidget);
    expect(find.text('John Doe'),
        findsWidgets); // Depending on how user names are displayed
    // expect(
    //     find.byType(TextFormField), findsOneWidget); // To check for input field
  });
}
