import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/change_password.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Change Password Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ChangePassword(),
        ),
      ),
    );

    expect(find.text('Change Password'), findsOneWidget);

    Finder currentpassword = find.byType(TextField).at(0);
    expect(currentpassword, findsOneWidget);
    await tester.enterText(currentpassword, '12345678aaA');
    expect(find.text('12345678aaA'), findsOneWidget);

    Finder newpassword = find.byKey(const Key('newPassword'));
    expect(newpassword, findsOneWidget);
    await tester.enterText(newpassword, '1111111122aA');
    expect(find.text('1111111122aA'), findsOneWidget);

    // Finder confirmpassword = find.byKey(const Key('confirmPassword'));
    // expect(confirmpassword, findsOneWidget);
    // await tester.enterText(confirmpassword, '1111111122aA');
    // expect(find.text('1111111122aA'), findsOneWidget);

    Finder savebutton = find.byKey(const Key('SaveButton'));
    await tester.tap(savebutton);
    expect(find.byType(ChangePassword), findsOneWidget);

    Finder cancelbutton = find.byKey(const Key('CancelButton'));
    await tester.tap(cancelbutton);

  });
}
