import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/Authentication/forget_password.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('LoginScreen Widget Test', (WidgetTester tester) async {
    // Mock the NetworkService

    await tester.pumpWidget(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<NetworkService>(
              create: (_) => MockNetworkService(),
            ),
            ChangeNotifierProvider<MenuState>(
              create: (_) =>
                  MenuState(), // Replace with your MenuState instance
            ),
          ],
          child: MaterialApp(
            home: const LoginScreen(),
          )),
    );

    // Verify that the LoginScreen widget is displayed.
    expect(find.byType(LoginScreen), findsOneWidget);

    // Find the username and password TextFields and the login button.

    final usernameField = find.byKey(Key('Username'));
    final passwordField = find.byKey(Key('Password'));
    final loginButton = find.byKey(Key('loginButton'));

    // Enter 'validUser' into the username TextField.
    await tester.enterText(usernameField, 'validUser');
    // Trigger the listener callback for emailController
    (tester.widget(usernameField) as TextFormField).controller!.text =
        'validUser';

    // Enter 'validPassword' into the password TextField.
    await tester.enterText(passwordField, 'validPassword');
    // Trigger the listener callback for passwordController
    (tester.widget(passwordField) as TextFormField).controller!.text =
        'validPassword';

    // Tap the login button.
    await tester.tap(loginButton);
    // Rebuild the widget after the state change.
    await tester.pumpAndSettle();
  });

  testWidgets('LoginScreen Widget Test - Invalid Password',
      (WidgetTester tester) async {
    // Mock the NetworkService
    final mockNetworkService = MockNetworkService();

    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => mockNetworkService,
        child: MaterialApp(
          home: const LoginScreen(),
        ),
      ),
    );

    // Verify that the LoginScreen widget is displayed.
    expect(find.byType(LoginScreen), findsOneWidget);

    // Find the username and password TextFields and the login button.
    final usernameField = find.byKey(Key('Username'));
    final passwordField = find.byKey(Key('Password'));
    final loginButton = find.byKey(Key('loginButton'));

    // Enter 'validUser' into the username TextField.
    await tester.enterText(usernameField, 'validUser');
    // Enter 'invalidPassword' into the password TextField.
    await tester.enterText(passwordField, 'invalidPassword');

    // Tap the login button.
    await tester.tap(loginButton);
// Rebuild the widget after the state change.
    await tester.pumpAndSettle();

// Verify that the LoginScreen widget is still displayed.
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  void main() {
    testWidgets('Click on ForgetPassword', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      // Find the "Forgot Password?" button.
      final forgotPasswordButton = find.byKey(Key('ForgotPassword'));

      // Tap on the "Forgot Password?" button.
      await tester.tap(forgotPasswordButton);

      // Rebuild the widget after the state has changed.
      await tester.pumpAndSettle();

      // Expect to find the "ForgetPassword" screen.
      expect(find.byType(ForgetPassword), findsOneWidget);
    });
  }

  testWidgets('Click on AgreementText', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Find the AgreementText widget.
    final agreementText = find.byType(AgreementText);

    // Tap on the AgreementText widget.
    await tester.tap(agreementText);

    // Rebuild the widget after the state has changed.
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('User Agreement '),
      ),
      findsOneWidget,
    );
  });
}
