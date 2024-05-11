import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/moderator/moderators.dart';

void main() {
  testWidgets('Moderator Widget Test', (WidgetTester tester) async {
    // Build the Moderator widget.
    await tester.pumpWidget(const MaterialApp(home: Moderator(communityName: 'test')));

    // Verify that the Moderator widget is rendered.
    expect(find.byType(Moderator), findsOneWidget);

    // Verify that the AppBar title is 'Moderators'.
    expect(find.text('Moderators'), findsOneWidget);

    // Verify that the back button is working correctly.
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();

    // Verify that the add button is working correctly.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the TabBar is present.
    expect(find.byType(TabBar), findsOneWidget);

    // Verify that the TabBarView is present.
    expect(find.byType(TabBarView), findsOneWidget);

    // Verify that the ListView is populated correctly.
    expect(find.byType(ListTile), findsWidgets);
    expect(find.byType(Divider), findsWidgets);

    // Verify that the IconButton in the ListTile is present.
    expect(find.byType(IconButton), findsWidgets);

    // Verify that the TabBar has two tabs.
    expect(find.byType(Tab), findsNWidgets(2));

    // Verify that the first tab is 'All'.
    expect(find.widgetWithText(Tab, 'All'), findsOneWidget);

    // Verify that the second tab is 'Editable'.
    expect(find.widgetWithText(Tab, 'Editable'), findsOneWidget);

    // Tap the 'Editable' tab.
    await tester.tap(find.text('Editable'));
    await tester.pump();

    // Verify that the 'Editable' tab is selected.
    expect(find.widgetWithText(Tab, 'Editable'), findsOneWidget);

  });
}