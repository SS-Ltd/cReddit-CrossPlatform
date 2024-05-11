import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/settings/muted_communities.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

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
    });
  });
}
