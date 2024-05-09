import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/common/block_pop_up.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('BlockPopUp displays the correct username and buttons',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: Scaffold(
            body: BlockPopUp(userName: 'TestUser'),
          ),
        ),
      ),
    );

    // Verify that our username is displayed.
    expect(find.text('Block u/TestUser?'), findsOneWidget);

    // Verify that our buttons are displayed.
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Block Account'), findsOneWidget);
    await tester.tap(find.text('Block Account'));
    await tester.pump(); // Trigger a frame
    expect(
        find.text('The Author of this post has been blocked.'), findsOneWidget);
  });
}
