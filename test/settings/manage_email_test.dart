import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/settings/manage_email.dart';

void main() {
  testWidgets('ManageEmails widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ManageEmails()));

    expect(find.text('Emails'), findsOneWidget);

    expect(find.text("MESSAGES"), findsOneWidget);
    expect(find.text("ACTIVITY"), findsOneWidget);
  });
}