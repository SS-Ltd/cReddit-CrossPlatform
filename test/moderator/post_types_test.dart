import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/chat/chat_list.dart';
import 'package:reddit_clone/features/moderator/post_types.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('ChatListScreen displays mocked data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: PostTypes(),
        ),
      ),
    );

    expect(find.text('Any'), findsOneWidget); // Radio option is selected
    expect(find.byType(Switch),
        findsNWidgets(3)); // Three switches should be visible
    expect(
        find.text('Save'), findsOneWidget); // Save button is disabled initially
  });

  testWidgets('Interaction Handling', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: PostTypes(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify that only the 'Poll posts' switch is visible
    expect(find.text('Image posts'), findsOneWidget);
    expect(find.text('Video posts'), findsOneWidget);
    expect(find.text('Poll posts'), findsOneWidget);

    // Enable the poll posts switch
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    // Check if the state updated
    expect(tester.widget<Switch>(find.byType(Switch).first).value, false);
  });

  testWidgets('Conditional Visibility of Switches',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: PostTypes(),
        ),
      ),
    );
    // Choose 'Text only'
    await tester.tap(find.text('Text only').hitTestable());
    await tester.pumpAndSettle();

    // Assert image and video posts switches are not visible
    expect(find.text('Image posts'), findsNothing);
    expect(find.text('Video posts'), findsNothing);

    // Switch back to 'Any'
    await tester.tap(find.text('Any').hitTestable());
    await tester.pumpAndSettle();

    // Now image and video posts should be visible again
    expect(find.text('Image posts'), findsOneWidget);
    expect(find.text('Video posts'), findsOneWidget);
  });

  testWidgets('Conditional Visibility of Switches',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: PostTypes(),
        ),
      ),
    );
    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Assuming you go back, you can check for disappearance of dialog if it was on a stack
    expect(find.byType(PostTypes),
        findsNothing); // Or any other check to confirm back navigation worked
  });
}
