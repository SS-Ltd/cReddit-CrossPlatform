import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/moderator/add_moderator.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Add moderators Page', (WidgetTester tester) async {
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
    expect(find.text('Add a moderator'), findsOneWidget);

    expect(find.text('Username'), findsOneWidget);

    expect(find.text('Permissions'), findsOneWidget);

    expect(find.text('Full permissions'), findsOneWidget);

    expect(find.text('Access'), findsOneWidget);

    expect(find.text('Mail'), findsOneWidget);

    expect(find.text('Config'), findsOneWidget);

    expect(find.text('Posts'), findsOneWidget);

    expect(find.text('Flair'), findsOneWidget);

    expect(find.text('Wiki'), findsOneWidget);

    expect(find.text('Chat config'), findsOneWidget);

    expect(find.text('Chat operator'), findsOneWidget);

    final Finder checkboxFinder0 = find.byKey(const Key('checkbox_0'));
    expect(checkboxFinder0, findsOneWidget);
    await tester.tap(checkboxFinder0);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_0')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder0).value, false);

    final Finder checkboxFinder1 = find.byKey(const Key('checkbox_1'));
    expect(checkboxFinder1, findsOneWidget);
    await tester.tap(checkboxFinder1);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_1')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder1).value, false);

    final Finder checkboxFinder2 = find.byKey(const Key('checkbox_2'));
    expect(checkboxFinder2, findsOneWidget);
    await tester.tap(checkboxFinder2);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_2')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder2).value, false);

    final Finder checkboxFinder3 = find.byKey(const Key('checkbox_3'));
    expect(checkboxFinder3, findsOneWidget);
    await tester.tap(checkboxFinder3);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_3')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder3).value, false);

    final Finder checkboxFinder4 = find.byKey(const Key('checkbox_4'));
    expect(checkboxFinder4, findsOneWidget);
    await tester.tap(checkboxFinder4);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_4')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder4).value, false);

    final Finder checkboxFinder5 = find.byKey(const Key('checkbox_5'));
    expect(checkboxFinder5, findsOneWidget);
    await tester.tap(checkboxFinder5);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_5')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder5).value, false);

    final Finder checkboxFinder6 = find.byKey(const Key('checkbox_6'));
    expect(checkboxFinder6, findsOneWidget);
    await tester.tap(checkboxFinder6);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_6')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder6).value, false);

    final Finder checkboxFinder7 = find.byKey(const Key('checkbox_7'));
    expect(checkboxFinder7, findsOneWidget);
    await tester.tap(checkboxFinder7);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_7')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder7).value, false);

    final Finder checkboxFinder8 = find.byKey(const Key('checkbox_8'));
    expect(checkboxFinder8, findsOneWidget);
    await tester.tap(checkboxFinder8);
    await tester.pump();
    expect(find.byKey(const Key('checkbox_8')), findsOneWidget);
    expect(tester.widget<Checkbox>(checkboxFinder8).value, false);

    
  });
}
