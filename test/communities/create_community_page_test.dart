import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/community/create_community_page.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('CreateCommunityPage Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: CreateCommunityPage(),
        ),
      ),
    );

    // Verify that the CreateCommunityPage is displayed
    expect(find.text('Create a Community'), findsOneWidget);

    // Verify that the "Create Community" button is initially disabled
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled, false);

    // Verify that the community name text field is initially empty
    expect(find.widgetWithText(TextField, ''), findsOneWidget);

    // Verify that the 18+ switch is initially off
    expect(tester.widget<Switch>(find.byType(Switch)).value, false);

    // Simulate entering text into the community name text field
    await tester.enterText(find.byType(TextField), 'test');
    await tester.pump();

    // Verify that the entered text is displayed in the text field
    expect(find.widgetWithText(TextField, 'test'), findsOneWidget);

    // Simulate toggling the 18+ switch
    await tester.tap(find.byType(Switch));
    await tester.pump();

    // Verify that the switch is now on
    expect(tester.widget<Switch>(find.byType(Switch)).value, true);
  });
}