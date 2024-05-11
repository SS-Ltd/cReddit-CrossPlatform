import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/settings.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {

  testWidgets('Settings Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: Settings(),
        ),
      ),
    );
  await tester.pumpAndSettle();
  expect(find.text('Settings'), findsOneWidget);

  expect(find.text('General'), findsOneWidget);

  expect(find.text('Get Premium'), findsOneWidget);

  expect(find.text('Change app icon'), findsOneWidget);

  expect(find.text('Create Avatar'), findsOneWidget);

  expect(find.text('Language'), findsOneWidget);

  expect(find.text('App Language'), findsOneWidget);

  expect(find.text('Content Language'), findsOneWidget);

  expect(find.text('View Options'), findsOneWidget);

  expect(find.text('Dark Mode'), findsOneWidget);

  expect(find.text('Default view'), findsOneWidget);

  expect(find.text('Autoplay'), findsOneWidget);  

  expect(find.text('Thumbnails'), findsOneWidget);

  expect(find.text('Reduce Animations'), findsOneWidget);

  expect(find.text("Show NSFW content (I'm over 18)"), findsOneWidget);

  expect(find.text('Blur NSFW images'), findsOneWidget);

  expect(find.text('Accessibility'), findsOneWidget);

  expect(find.text('Increase Text Size'), findsOneWidget);

  expect(find.text('Auto Dark Mode'), findsOneWidget);

  expect(find.text('Dark Mode'), findsOneWidget);

  expect(find.text('Light theme'), findsOneWidget);

  expect(find.text('Dark theme'), findsOneWidget);

  expect(find.text('Advanced'), findsOneWidget);

  expect(find.text('Saved image attribution'), findsOneWidget);

  expect(find.text('Comment jump button'), findsOneWidget);

  expect(find.text('Default comment sort'), findsOneWidget);

  expect(find.text('Export video log'), findsOneWidget);

  expect(find.text('Content Policy'), findsOneWidget);

  expect(find.text('Privacy Policy'), findsOneWidget);

  expect(find.text('User Agreement'), findsOneWidget);

  expect(find.text('Acknowledgments'), findsOneWidget);

  expect(find.text('Support'), findsOneWidget);

  expect(find.text('Help Center'), findsOneWidget);

  expect(find.text('Visit r/redditmobile'), findsOneWidget);

  expect(find.text('Report an issue'), findsOneWidget);
  });
}
