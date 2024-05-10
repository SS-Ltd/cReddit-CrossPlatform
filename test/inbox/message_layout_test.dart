import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/Inbox/message_layout.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  testWidgets('MessageLayout widget test', (WidgetTester tester) async {
    // Create a sample message
    final message = Messages(
      id: 'id1',
      from: 'from1',
      to: 'to1',
      subject: 'subject1',
      text: 'text1',
      isRead: false,
      isDeleted: false,
      createdAt: DateTime.now().toString(),
    );

    // Build the MessageLayout widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MessageLayout(
          message: message,
          onTap: () {},
        ),
      ),
    ));

    // Verify the presence of elements
    expect(find.byIcon(Icons.mail), findsOneWidget); // Unread mail icon
    expect(find.text('subject1'), findsOneWidget); // Subject
    expect(find.text('text1'), findsOneWidget); // Text
    expect(find.text('u/from1 • ${formatTimestamp(DateTime.now())}'), findsOneWidget); // From
    expect(find.byIcon(Icons.more_vert), findsOneWidget); // More options icon
  });

  testWidgets('MessageLayout widget test - read message', (WidgetTester tester) async {
    // Create a sample read message
    final message = Messages(
      id: 'id1',
      from: 'from1',
      to: 'to1',
      subject: 'subject1',
      text: 'text1',
      isRead: true, // This message is read
      isDeleted: false,
      createdAt: DateTime.now().toString(),
    );

    // Build the MessageLayout widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MessageLayout(
          message: message,
          onTap: () {},
        ),
      ),
    ));

    // Verify the presence of elements
    expect(find.byIcon(Icons.mail_outline), findsOneWidget); // Read mail icon
    expect(find.text('subject1'), findsOneWidget); // Subject
    expect(find.text('text1'), findsOneWidget); // Text
    expect(find.text('u/from1 • ${formatTimestamp(DateTime.now())}'), findsOneWidget); // From
    expect(find.byIcon(Icons.more_vert), findsOneWidget); // More options icon
  });

  testWidgets('MessageLayout widget test - onTap callback', (WidgetTester tester) async {
    // Create a sample message
    final message = Messages(
      id: 'id1',
      from: 'from1',
      to: 'to1',
      subject: 'subject1',
      text: 'text1',
      isRead: false,
      isDeleted: false,
      createdAt: DateTime.now().toString(),
    );
  
    bool onTapCalled = false;
  
    // Build the MessageLayout widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MessageLayout(
          message: message,
          onTap: () {
            onTapCalled = true;
          },
        ),
      ),
    ));
  
    // Tap the ListTile
    await tester.tap(find.byType(ListTile));
    await tester.pump();
  
    // Verify that the onTap callback was called
    expect(onTapCalled, isTrue);
  });
}