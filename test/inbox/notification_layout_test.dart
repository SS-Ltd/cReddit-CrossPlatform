import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/Inbox/notification_layout.dart';
import 'package:reddit_clone/models/notification.dart';
import 'package:reddit_clone/utils/utils_time.dart';

void main() {
  testWidgets('NotificationLayout widget test', (WidgetTester tester) async {
    // Create a mock notification
    final notification = NotificationModel(
      id: 'mock-id',
      user: 'mock-user',
      notificationFrom: 'mock-notificationFrom',
      type: 'mock-type',
      resourceId: 'mock-resourceId',
      title: 'mock-title',
      content: 'mock-content',
      isRead: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profilePic: 'assets/hehe.png',
    );

    // Build the NotificationLayout widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NotificationLayout(
          notification: notification,
          onTap: () {},
        ),
      ),
    ));

    // Verify that the ListTile is displayed
    expect(find.byType(ListTile), findsOneWidget);

    // Find all RichText widgets
    final richTextFinders = find.byType(RichText);

    // Verify that the TextSpan children are correct
    richTextFinders.evaluate().forEach((element) {
      final widget = element.widget as RichText;
      final textSpan = widget.text as TextSpan;
      final plainText = textSpan.toPlainText();

      if (plainText.contains('mock-title')) {
        expect(plainText, contains('mock-title'));
        expect(plainText, contains(' • ${formatTimestamp(notification.updatedAt)}'));
      } else if (plainText.contains('mock-content')) {
        expect(plainText, 'mock-content');
      }
    });

    // Verify that the more options icon is displayed
    expect(find.byIcon(Icons.more_vert), findsOneWidget);
  });
}