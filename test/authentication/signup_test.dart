import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/Authentication/forget_password.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('LoginScreen Widget Test', (WidgetTester tester) async {
    // Mock the NetworkService

    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: SignUpScreen(),
        ),
      ),
    );

    // Verify that the LoginScreen widget is displayed.
    expect(find.byType(SignUpScreen), findsOneWidget);

    // Find the username and password TextFields and the login button.

    final usernameField = find.byKey(Key('Email'));
    final passwordField = find.byKey(Key('Password'));
    final signupButton = find.byKey(Key('signupButton'));

    // Enter 'validUser' into the username TextField.
    await tester.enterText(usernameField, 'validUser');
    // Enter 'validPassword' into the password TextField.
    await tester.enterText(passwordField, 'validPassword');

    // Tap the login button.
    await tester.tap(signupButton);
    // Rebuild the widget after the state change.
    await tester.pumpAndSettle();
  });
}
