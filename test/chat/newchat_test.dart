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
        child: MaterialApp(
          home: const NewChatPage(),
        ),
      ),
    );

    // Pump to settle the asynchronous operations
    await tester.pumpAndSettle();

    // Check if the ChatScreen shows the expected messages and elements
    // Verify the presence of search field and initial UI elements
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.byType(Chip), findsNothing); // No selected users initially
  });
}
