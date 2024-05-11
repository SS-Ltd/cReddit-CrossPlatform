import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/settings/reset_username.dart';

void main() {
  testWidgets('Reset Username widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResetUsername()));

    expect(find.text('Recover username?'), findsOneWidget);

    expect(find.text("Email address for your account"), findsOneWidget);
    
    expect(find.text("Having Trouble?"), findsOneWidget);
    expect(
        find.text('Unfortunately, if you have never given us your email,'
            ' we will not be able to reset your password.'),
        findsOneWidget);

    expect(find.text("CANCEL"), findsOneWidget);
    expect(find.text("EMAIL ME"), findsOneWidget);

    expect(find.byKey(const Key('having_trouble_button')), findsOneWidget);
    expect(find.byKey(const Key('cancel_button')), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'test');
  });
}
