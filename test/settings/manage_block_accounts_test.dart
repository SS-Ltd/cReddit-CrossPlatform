import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/manage_blocked_accounts.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ManageBlockedAccounts widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: Builder(
            builder: (context) =>
                const MaterialApp(home: ManageBlockedAccounts())),
      ),
    );

    expect(find.text('Blocked accounts'), findsOneWidget);

    expect(find.text("Block new account"), findsOneWidget);
  });
}
