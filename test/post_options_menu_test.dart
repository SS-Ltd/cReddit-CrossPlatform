import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/post_options_menu.dart';

void main() {
  testWidgets('PostOptionsMenu displays all options',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: PostOptionsMenu(profile: true))));

    // Open the popup menu
    await tester.tap(find.byType(PopupMenuButton<Menu>));
    await tester.pumpAndSettle(); // Finish the menu animation

    // Check for all the menu items
    expect(
        find.text('Share'),
        findsNWidgets(
            2)); // 'Share' appears twice, once in "Share" and once in "Save"
    expect(find.text('Subscribe'), findsOneWidget);
    //   expect(find.text('Save'), findsOneWidget);
    expect(find.text('Copy text'), findsOneWidget);
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Add post flair'), findsOneWidget);
    expect(find.text('Mark spoiler'), findsOneWidget);
    expect(find.text('Mark NSFW'), findsOneWidget);
    expect(find.text('Mark as brand affiliate'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
  });
}
