import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/common/block_pop_up.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('AboutUserPopUp displays the username correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: AboutUserPopUp(userName: 'mockUser'),
        ),
      ),
    );
    expect(find.text('u/mockUser'), findsOneWidget);
  });

  testWidgets('AboutUserPopUp navigation to Profile works correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: AboutUserPopUp(userName: 'mockUser'),
        ),
      ),
    );
    await tester.tap(find.widgetWithText(ArrowButton, 'View Profile'));
    await tester.pumpAndSettle(); // This settles the navigation animation
  });

  testWidgets('AboutUserPopUp opens BlockPopUp when "Block Account" is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: AboutUserPopUp(userName: 'mockUser'),
        ),
      ),
    );
    await tester.tap(find.widgetWithText(ArrowButton, "Block Account"));
    await tester
        .pumpAndSettle(); // Might need pumpAndSettle depending on your showDialog implementation

    expect(find.byType(BlockPopUp), findsOneWidget);
  });
}
