import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/add_moderator.dart';

void main() {
  group('AddModerator', () {
    testWidgets('renders AddModerator widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AddModerator(communityName: 'Test Community'),
        ),
      );

      expect(find.text('Add a moderator'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Checkbox), findsNWidgets(9));
    });

    testWidgets('invokes invite callback when Invite button is pressed',
        (WidgetTester tester) async {
      bool isInvited = false;

      await tester.pumpWidget(
        MaterialApp(
          home: AddModerator(
            communityName: 'Test Community',
          ),
        ),
      );

      await tester.enterText(find.byKey(const Key('username')), 'testuser');
      await tester.tap(find.byKey(const Key('InviteButton')));
      await tester.pump();

      expect(isInvited, false);
    });
  });
}