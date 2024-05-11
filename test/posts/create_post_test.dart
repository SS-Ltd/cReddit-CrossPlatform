import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/post/create_post.dart';

void main() {
  group('CreatePost', () {
    testWidgets('should render CreatePost widget', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byType(CreatePost), findsOneWidget);
    });

    testWidgets('should render title TextField', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byKey(const Key('title')), findsOneWidget);
    });

    testWidgets('should render body TextField', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byKey(const Key('body')), findsOneWidget);
    });

    testWidgets('should render add link IconButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byIcon(Icons.link), findsOneWidget);
    });

    testWidgets('should render add image IconButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('should render add video IconButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byIcon(Icons.video_library_outlined), findsOneWidget);
    });

    testWidgets('should render add poll IconButton',
        (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.byIcon(Icons.poll_outlined), findsOneWidget);
    });

    testWidgets('should render Post button', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: false));
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('should render Schedule button', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: false, ismoderator: true));
      expect(find.text('Schedule'), findsOneWidget);
    });

    testWidgets('should render Next button', (WidgetTester tester) async {
      await tester.pumpWidget(CreatePost(profile: true, ismoderator: false));
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets(
        'CreatePost should open the link insertion when the link button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePost(profile: false)));

      await tester.tap(find.byIcon(Icons.link));
      await tester.pumpAndSettle();

      expect(find.byKey(Key('Insert Link')), findsOneWidget);
    });

    testWidgets('CreatePost should have a title TextField',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePost(profile: false)));

      expect(find.byKey(Key('title')), findsOneWidget);
    });

    testWidgets('CreatePost should have a body TextField',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePost(profile: false)));

      expect(find.byKey(Key('body')), findsOneWidget);
    });

    testWidgets('CreatePost should have a Post button',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePost(profile: false)));

      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('CreatePost should show the chosen community',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CreatePost(profile: false)));

      // Simulate selecting a community
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('chosenCommunity'), findsOneWidget);
    });
  });
}
