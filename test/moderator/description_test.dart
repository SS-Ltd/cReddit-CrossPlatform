import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/moderator/description.dart' as ModeratorDescription;
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Description Widget Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: ModeratorDescription.Description(),
        ),
      ),
    );

    expect(find.text('Description'), findsOneWidget);

    expect(find.widgetWithText(TextField, ''), findsOneWidget);

    // Simulate entering text into the community name text field
    await tester.enterText(find.byType(TextField), 'this is my community');
    await tester.pump();

    // Verify that the entered text is displayed in the text field
    expect(find.widgetWithText(TextField, 'this is my community'), findsOneWidget);

    // Verify that the save button is disabled when the description is empty
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    expect(tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Save')).enabled, isFalse);

    // Simulate entering text into the description text field
    await tester.enterText(find.byType(TextField), 'Some description');
    await tester.pump();

    // Verify that the save button is enabled when the description is not empty
    expect(tester.widget<ElevatedButton>(find.widgetWithText(ElevatedButton, 'Save')).enabled, isTrue);
  });
}