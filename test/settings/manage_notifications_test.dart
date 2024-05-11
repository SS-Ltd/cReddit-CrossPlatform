import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/manage_notifications.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {

  testWidgets('Manage Notifications Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ManageNotifications(),
        ),
      ),
    );
  await tester.pumpAndSettle();
  expect(find.text('Notifications'), findsOneWidget);

  expect(find.text('ACTIVITY'), findsOneWidget);

  expect(find.text('Mentions of u/username'), findsOneWidget);

  expect(find.text('Comments on your posts'), findsOneWidget);

  expect(find.text('Upvotes on your posts'), findsOneWidget);

  expect(find.text('Replies to your comments'), findsOneWidget);

  expect(find.text('New followers'), findsOneWidget);

  expect(find.text('UPDATES'), findsOneWidget);

  expect(find.text('Cake day'), findsOneWidget);

  expect(find.text('MODERATION'), findsOneWidget);

  expect(find.text('Mod notifications'), findsOneWidget);
  });
}
