import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/settings/forgot_password.dart';

void main() {
  testWidgets('Forgot Password widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ForgotPassword()));

    expect(find.text('Forgot your password?'), findsOneWidget);

    expect(find.text("Forgot username"), findsOneWidget);

    expect(find.text("Unfortunately, if you have never given us your email, we will not be able to reset your password."), findsOneWidget);
    
    expect(find.text("Having Trouble?"), findsOneWidget);
    expect(find.text("CANCEL"), findsOneWidget);
    expect(find.text("EMAIL ME"), findsOneWidget);

    expect(find.byKey(const Key('forgot_username_button')), findsOneWidget);
    expect(find.byKey(const Key('having_trouble_button')), findsOneWidget);
    expect(find.byKey(const Key('cancel_button')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('username_field')), 'test');

  });
}
