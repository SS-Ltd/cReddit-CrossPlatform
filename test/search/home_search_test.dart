import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/search/home_search.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('HomeSearch widget test', (WidgetTester tester) async {
    // Build the HomeSearch widget
    await tester.pumpWidget(MaterialApp(home: HomeSearch()));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(home: HomeSearch()),
      ),
    );
    // Verify that the HomeSearch widget is on screen
    expect(find.byType(HomeSearch), findsOneWidget);
  });

  testWidgets('HomeSearch widget test - search', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(home: HomeSearch()),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    final postsFieldFinder = find.byKey(Key('Posts'));
    final commentsFieldFinder = find.byKey(Key('Comments'));

    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pump();

    // Verify that the TextField contains the entered text
    expect(find.text('abc'), findsOneWidget);

    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();
  });

  testWidgets('HomeSearch widget test - posts', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(home: HomeSearch()),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    final postsFieldFinder = find.byKey(Key('Posts'));
    // final commentsFieldFinder = find.byKey(Key('Comments'));
    // final usersFieldFinder = find.byKey(Key('People'));
    // final communitiesFieldFinder = find.byKey(Key('Communities'));
    // final hashtagFieldFinder = find.byKey(Key('Hashtags'));
    // Verify that the TextField is on screen
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pump();

    // // Verify that the TextField contains the entered text
    // expect(find.text('abc'), findsOneWidget);
    print(findsOneWidget);
    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();

    await tester.tap(postsFieldFinder);
    await tester.pump();
    // await tester.tap(commentsFieldFinder);
    // await tester.pump();
    // await tester.tap(usersFieldFinder);
    // await tester.pump();
    // await tester.tap(communitiesFieldFinder);
    // await tester.pump();
    // await tester.tap(hashtagFieldFinder);
    // await tester.pump();
  });

  testWidgets('HomeSearch widget test - comments', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(home: HomeSearch()),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    final postsFieldFinder = find.text('Posts');
    final commentsFieldFinder = find.text('Comments');
    final usersFieldFinder = find.text('People');
    final communitiesFieldFinder = find.text('Communities');
    // final hashtagFieldFinder = find.byKey(Key('Hashtags'));
    // Verify that the TextField is on screen
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pumpAndSettle();

    // // Verify that the TextField contains the entered text
    // expect(find.text('abc'), findsOneWidget);
    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();

    print(communitiesFieldFinder);

    await tester.tap(postsFieldFinder);
    await tester.pumpAndSettle();
    await tester.tap(commentsFieldFinder);
    await tester.pumpAndSettle();
    await tester.tap(usersFieldFinder);

    await tester.tap(communitiesFieldFinder);
    await tester.pumpAndSettle();
    // await tester.tap(hashtagFieldFinder);
    // await tester.pump();
  });
}
