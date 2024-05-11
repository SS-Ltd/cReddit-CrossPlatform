import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/manage_email.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ManageEmails widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: Builder(
            builder: (context) => const MaterialApp(home: ManageEmails())),
      ),
    );

    expect(find.text('Emails'), findsOneWidget);

    expect(find.text("MESSAGES"), findsOneWidget);
    expect(find.text("ACTIVITY"), findsOneWidget);
  });
}
