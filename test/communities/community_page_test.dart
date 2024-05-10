import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/Community/community_page.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Community Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: CommunityPage(),
        ),
      ),
    );

    // Verify that a loading indicator is shown initially
    expect(find.byType(CustomLoadingIndicator), findsOneWidget);
    // Pump to settle the asynchronous operations
    await tester.pumpAndSettle();

    expect(find.text('Annamae.Rohan10'), findsOneWidget);
    expect(find.text('100 members'), findsOneWidget);
    expect(
        find.text(
            'Sunt capio vapulus deorsum ultio comburo validus defessus. Ait caritas utique earum sumptus bibo assentator. Sulum vitae laborum pauper pax aestas ipsum currus nam caute.'),
        findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Join'), findsAny);

  });

  testWidgets('Community Page when isJoined is true', (WidgetTester tester) async {
     await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: CommunityPage(),
        ),
      ),
    );
    // Verify that a loading indicator is shown initially
    expect(find.byType(CustomLoadingIndicator), findsOneWidget);

    // Pump to settle the asynchronous operations
    await tester.pumpAndSettle();

    // Verify that the community is displayed
    expect(find.text('Carlotta.Kreiger61'), findsOneWidget);
    expect(find.text('95 members'), findsOneWidget);
    expect(
      find.text(
        'Qui absum aiunt vehemens cernuus cenaculum accendo alveus occaecati bonus. Voluptate arbitro caste celo quaerat concedo. Summa strues vereor spero.',
      ),
      findsOneWidget,
    );

    // Verify that the button text is 'Leave' because isJoined is true
    expect(find.widgetWithText(ElevatedButton, 'Joined'), findsOneWidget);
  });
}
