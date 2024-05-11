import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/moderator/add_moderator.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Post types Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: AddModerator(
            communityName: '',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // expect(find.text('Post types'), findsOneWidget);

    // expect(find.text('Save'), findsOneWidget);

    // final Finder modelsheet = find.byKey(const Key('openmodel'));
    // expect(modelsheet, findsOneWidget);
    // await tester.tap(modelsheet);
    // await tester.pump();
    // expect(find.byKey(const Key('openmodel')), findsOneWidget);

    // expect(find.text('Any'), findsOneWidget);

    // expect(find.text('Allow text, link, image, and video posts'), findsOneWidget);

    // expect(find.text('Link only'), findsOneWidget);

    // expect(find.text('Only allow link posts'), findsOneWidget);

    // expect(find.text('Text only'), findsOneWidget);

    // expect(find.text('Only allow text posts'), findsOneWidget);

    // expect(find.text('Post type options'), findsOneWidget);

    // expect(find.text('Choose the types of posts you allow in your community'), findsOneWidget);

    // expect(find.text('Image posts'), findsOneWidget);

    // expect(find.text('Allow images uploaded directly to Reddit as well as links to popular image hosting sites such as lmgur,'), findsOneWidget);

    // expect(find.text('Video posts'), findsOneWidget);

    // expect(find.text('Allow videos uploaded directly to Reddit'), findsOneWidget);

    expect(find.text("Poll posts"), findsOneWidget);

    expect(find.text('Allow poll posts in your community'), findsOneWidget);



    // final Finder radioListTileFinder0 = find.byKey(const Key('radioListTile_0'));

    // final Finder checkboxFinder0 = find.byKey(const Key('checkbox_0'));
    // expect(checkboxFinder0, findsOneWidget);
    // await tester.tap(checkboxFinder0);
    // await tester.pump();
    // expect(find.byKey(const Key('checkbox_0')), findsOneWidget);
    // expect(tester.widget<Checkbox>(checkboxFinder0).value, false);

    
  });
}
