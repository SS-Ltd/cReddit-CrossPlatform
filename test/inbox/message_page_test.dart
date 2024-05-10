import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/Inbox/message_page.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  final mockMessage = Messages(
    id: 'mock-id',
    from: 'mock-from',
    to: 'mock-to',
    subject: 'mock-subject',
    text: 'mock-text',
    isRead: true,
    isDeleted: false,
    createdAt: DateTime.now().toString(),
  );

  testWidgets('MessagePage shows the correct message data', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MessagePage(message: mockMessage)));

    expect(find.text('u/${mockMessage.from}'), findsOneWidget);
    expect(find.text(mockMessage.subject), findsOneWidget);
    expect(find.text("${mockMessage.from} • ${formatTimestamp(DateTime.parse(mockMessage.createdAt))}"), findsOneWidget);
    expect(find.text(mockMessage.text), findsOneWidget);
  });
}