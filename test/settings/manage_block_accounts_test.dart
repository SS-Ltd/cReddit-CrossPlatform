import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/settings/manage_blocked_accounts.dart';

void main() {
  testWidgets('ManageBlockedAccounts widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ManageBlockedAccounts()));

    expect(find.text('Blocked accounts'), findsOneWidget);

    expect(find.text("Block new account"), findsOneWidget);
  });
}