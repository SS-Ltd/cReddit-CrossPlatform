import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/User/report_button.dart';
import 'package:reddit_clone/features/chat/chat_list.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('displays modal bottom sheet with reasons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: Scaffold(
            body: ReportButton(
                subredditName: 'testSub', isPost: true, postId: '123'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(ReportButton));
    await tester.pumpAndSettle();

    expect(find.text('Submit a Report'), findsOneWidget);
    expect(find.text('Spam'), findsOneWidget);
    expect(find.text('Harassment'), findsOneWidget);
  });

  testWidgets('calls report function with selected reason',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: Scaffold(
            body: ReportButton(
                subredditName: 'testSub', isPost: true, postId: '123'),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byType(ReportButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Spam'));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  });
}
