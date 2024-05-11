import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/post/choose_community.dart';
import 'package:reddit_clone/features/post/share.dart';

void main() {
  group('ChooseCommunity', () {
    testWidgets('renders ChooseCommunity widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChooseCommunity(
            homePage: true,
            post: null,
          ),
        ),
      );

      expect(find.text('Choose a Community'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Joined'), findsOneWidget);
      expect(find.text('Recently Visited'), findsOneWidget);
    });

    testWidgets('tapping My Profile navigates to Share widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChooseCommunity(
            homePage: true,
            post: null,
          ),
        ),
      );

      await tester.tap(find.text('My Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(Share), findsOneWidget);
    });

    testWidgets('tapping a joined community navigates to Share widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChooseCommunity(
            homePage: true,
            post: null,
          ),
        ),
      );

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      expect(find.byType(Share), findsOneWidget);
    });

    testWidgets('tapping a recently visited community navigates to Share widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ChooseCommunity(
            homePage: true,
            post: null,
          ),
        ),
      );

      await tester.tap(find.byType(ListTile).at(2));
      await tester.pumpAndSettle();

      expect(find.byType(Share), findsOneWidget);
    });
  });
}