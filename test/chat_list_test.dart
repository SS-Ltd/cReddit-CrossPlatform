import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/chat/chat_list.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ChatListScreen displays mocked data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ChatListScreen(channelInfo: []),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Test Chat 1'), findsOneWidget);
    expect(find.text('Hello'), findsWidgets);
  });
}
