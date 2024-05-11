import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/post/community_choice.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('CommunityChoice widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: Builder(
          builder: (context) => const MaterialApp(
            home: CommunityChoice(),
          ),
        ),
      ),
    );

    expect(find.text('Post to'), findsOneWidget);
  });
}
