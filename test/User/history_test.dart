import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/User/history.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('HistoryPage loads and displays posts correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('User Post'), findsOneWidget);
  });
  testWidgets('HistoryPage changes sort and reloads data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_drop_down));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Upvoted'));
    await tester.pumpAndSettle();

    expect(find.text('Upvoted'), findsOneWidget);
    expect(find.text('User Post'), findsOneWidget);
  });
}
