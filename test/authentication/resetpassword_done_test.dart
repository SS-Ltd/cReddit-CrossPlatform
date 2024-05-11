import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/Authentication/reset_password_done.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:mockito/mockito.dart';

class MockNetworkService extends Mock implements NetworkService {}

void main() {
  testWidgets('ResetPasswordDone Widget Test', (WidgetTester tester) async {
    // Build the ResetPasswordDone widget
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: MaterialApp(
          home: ResetPasswordDone(email: 'zahar@gmail.com',),
        ),
      ),
    );


    // Verify that the ResetPasswordDone is displayed
    expect(find.text('Check your inbox'), findsOneWidget);
    expect(find.text('We send a password reset link to the email associated with your account'), findsOneWidget);
    expect(find.text('Didn\'t get an email? '), findsOneWidget);
    expect(find.text('Open email app'), findsOneWidget);

    // Simulate tapping the "Resend" button
    await tester.tap(find.text('Resend'));
    await tester.pump();

    // Simulate tapping the "Open email app" button
    await tester.tap(find.text('Open email app'));
    await tester.pump();

  });
}