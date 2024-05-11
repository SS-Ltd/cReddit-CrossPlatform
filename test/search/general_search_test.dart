import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/search/general_search.dart';
import 'package:reddit_clone/features/search/home_search.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('GeneralSearch widget test', (WidgetTester tester) async {
    // Build the GeneralSearch widget
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Verify that the GeneralSearch widget is on screen
    expect(find.byType(GeneralSearch), findsOneWidget);
  });

  testWidgets('GeneralSearch widget test - search',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));

    print(textFieldFinder);

    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pump();

    // Verify that the TextField contains the entered text
    expect(find.text('abc'), findsOneWidget);

    final searchButtonFinder = find.byKey(Key('search for'));
    print(searchButtonFinder);
    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();
  });

  testWidgets('GeneralSearch widget test - posts', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    final postsFieldFinder = find.byKey(Key('Posts'));

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
  });

  testWidgets('GeneralSearch widget test - comments',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    final postsFieldFinder = find.text('Posts');
    final commentsFieldFinder = find.text('Comments');
    final hashtagFieldFinder = find.text('Hashtags');
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

    await tester.tap(postsFieldFinder);
    await tester.pumpAndSettle();
    await tester.tap(commentsFieldFinder);
    await tester.pumpAndSettle();
    await tester.tap(hashtagFieldFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('GeneralSearch widget test - Hot', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    // Verify that the TextField is on screen
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pumpAndSettle();

    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();

    var sortFieldFinder = find.text('Sort');
    expect(sortFieldFinder, findsOneWidget);

    await tester.tap(sortFieldFinder);
    await tester.pumpAndSettle();
    final hotFieldFinder = find.byKey(Key('Hot'));
    await tester.tap(hotFieldFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('GeneralSearch widget test - Top', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    // Verify that the TextField is on screen
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pumpAndSettle();

    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();

    var sortFieldFinder = find.text('Sort');
    expect(sortFieldFinder, findsOneWidget);

    await tester.tap(sortFieldFinder);
    await tester.pumpAndSettle();
    final hotFieldFinder = find.byKey(Key('Top'));
    await tester.tap(hotFieldFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('GeneralSearch widget test - New', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NetworkService>(
            create: (_) => MockNetworkService(),
          ),
        ],
        child: MaterialApp(
            home: GeneralSearch(
          communityName: ' ',
          displayName: ' ',
          username: '',
        )),
      ),
    );
    // Find the TextField with the label "search text"
    final textFieldFinder = find.byKey(Key('search text'));
    final searchButtonFinder = find.byKey(Key('search for'));

    // Verify that the TextField is on screen
    expect(textFieldFinder, findsOneWidget);

    // Enter text into the TextField
    await tester.enterText(textFieldFinder, 'abc');
    await tester.pumpAndSettle();

    expect(searchButtonFinder, findsOneWidget);
    await tester.tap(searchButtonFinder);
    await tester.pump();

    var sortFieldFinder = find.text('Sort');
    expect(sortFieldFinder, findsOneWidget);

    await tester.tap(sortFieldFinder);
    await tester.pumpAndSettle();
    final hotFieldFinder = find.byKey(Key('New'));
    await tester.tap(hotFieldFinder);
    await tester.pumpAndSettle();
  });
}
