import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/account_settings.dart';
import 'package:reddit_clone/features/settings/settings.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
//  Settings settings = Settings();

  testWidgets('Settings Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: Settings(),
        ),
      ),
    );

    expect(find.byType(Settings), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    Finder appBarFinder = find.byType(AppBar);
    expect(appBarFinder, findsOneWidget);

    Finder buttonFinder = find.descendant(
      of: appBarFinder,
      matching: find.byTooltip('Back'),
    );
    expect(buttonFinder, findsOneWidget);



    Finder account = find.byKey(const Key('AccountSettingsButton'));
    expect(account, findsOneWidget);
    await tester.tap(account);
    await tester.pumpAndSettle();
    expect(find.byType(AccountSettings), findsOneWidget);


    // bool initialReduceAnimations = settings.reduceAnimations;
    // print(initialReduceAnimations);
    Finder reduceAnimations = find.byKey(const Key('ReduceAnimationsButton'));
    expect(reduceAnimations, findsOneWidget);
    await tester.tap(reduceAnimations);
    // await tester.pumpAndSettle();
    // print(settings.reduceAnimations);
    // expect(settings.reduceAnimations, !initialReduceAnimations);

    Finder showNSFW = find.byKey(const Key('ShowNSFWButton'));
    expect(showNSFW, findsOneWidget);
    await tester.tap(showNSFW);

    Finder blurNSFW = find.byKey(const Key('BlurNSFWButton'));
    expect(blurNSFW, findsOneWidget);
    await tester.tap(blurNSFW);

    Finder darkMode = find.byKey(const Key('DarkModeButton'));
    expect(darkMode, findsOneWidget);
    await tester.tap(darkMode);

    Finder saveButton = find.byKey(const Key('SavedImagesButton'));
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);

    Finder commentJump = find.byKey(const Key('CommentJumpButton'));
    expect(commentJump, findsOneWidget);
    await tester.tap(commentJump);

    // Finder cancelbutton = find.byKey(const Key('CancelButton'));
    // await tester.tap(cancelbutton);
  });
}
