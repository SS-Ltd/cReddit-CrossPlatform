import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/banned_users.dart';

void main() {
  testWidgets('Banned Users widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: BannedUser(communityName: '',)));

    expect(find.text('Banned users'), findsOneWidget);

    expect(find.byKey(const Key('backButton')), findsOneWidget);
    expect(find.byKey(const Key('addButton')), findsOneWidget);

    expect(find.byType(IconButton), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test');
  });
}
