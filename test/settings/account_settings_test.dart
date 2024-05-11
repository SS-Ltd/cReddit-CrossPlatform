import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/account_settings.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('AccountSettings widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: Builder(
          builder: (context) => const MaterialApp(
            home: AccountSettings(),
          ),
        ),
      ),
    );

    expect(find.text('Account Settings'), findsOneWidget);

    expect(find.text("MESSAGES"), findsOneWidget);
    expect(find.text("ACTIVITY"), findsOneWidget);
  });
}