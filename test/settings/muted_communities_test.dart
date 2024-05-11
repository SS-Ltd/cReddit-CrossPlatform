import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/settings/muted_communities.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

class MockNetworkService extends Mock implements NetworkService {}

void main() {
  group('MutedCommunities', () {
    testWidgets('shows loading indicator while waiting for future',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<NetworkService>(
          create: (_) => MockNetworkService(),
          child: Builder(
              builder: (context) =>
                  const MaterialApp(home: MutedCommunities())),
        ),
      );

      expect(find.text("Muted communities"), findsOneWidget);
      expect(find.text('Posts from muted communities will not show up in'),
          findsOneWidget);
      expect(find.text('your feeds or recommendations.'), findsOneWidget);
      expect(find.text('Search Communities'), findsOneWidget);
      expect(find.text("Community has been muted"), findsOneWidget);
      expect(find.text("Mute"), findsOneWidget);
      expect(find.text('Unmute'), findsOneWidget);
    });
  });
}
