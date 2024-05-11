import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/moderator/add_approved.dart';

void main() {
  testWidgets('Add Approved widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddApproved()));

    expect(find.text('Add an approved user'), findsOneWidget);
    expect(find.text("Username"), findsOneWidget);
    expect(find.text('This user will be able to submit cpntent to your community'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'test');
  });
}
