import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/forgot_password.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Forgot Password', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ForgotPassword(),
        ),
      ),
    );

    expect(find.text('Forgot your password?'), findsOneWidget);

    Finder username = find.byType(TextField).at(0);
    expect(username, findsOneWidget);
    await tester.enterText(username, 'usama.nn201@gmail.com');
    expect(find.text('usama.nn201@gmail.com'), findsOneWidget);

    Finder email = find.byType(TextField).at(1);
    expect(email, findsOneWidget);
    await tester.enterText(email, '12234556');
    expect(find.text('12234556'), findsOneWidget);

    // Finder savebutton = find.byKey(const Key('SaveButton'));
    // await tester.tap(savebutton);
    // expect(find.byType(UpdateEmail), findsOneWidget);

  });
}
