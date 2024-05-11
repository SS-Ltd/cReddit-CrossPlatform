import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/update_email.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Moderators page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: UpdateEmail(),
        ),
      ),
    );

    expect(find.text('Moderators'), findsOneWidget);

    Finder appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);

    Finder buttonFinder = find.descendant(
      of: appBarFinder,
      matching: find
          .byTooltip('Back'),
    );
    expect(buttonFinder, findsOneWidget);

    buttonFinder = find.descendant(
      of: appBarFinder,
      matching: find
          .byTooltip('Add moderator'),
    );
    expect(buttonFinder, findsOneWidget);

    // Finder newemail = find.byType(TextField).at(0);
    // expect(newemail, findsOneWidget);
    // await tester.enterText(newemail, 'usama.nn201@gmail.com');
    // expect(find.text('usama.nn201@gmail.com'), findsOneWidget);

    // Finder currentpassword = find.byType(TextField).at(1);
    // expect(currentpassword, findsOneWidget);
    // await tester.enterText(currentpassword, '12234556');
    // expect(find.text('12234556'), findsOneWidget);

    // Finder savebutton = find.byKey(const Key('SaveButton'));
    // await tester.tap(savebutton);
    // expect(find.byType(UpdateEmail), findsOneWidget);
;
  });
}
