import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/moderator/schedule_posts.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('CommunityChoice widget test', (WidgetTester tester) async {
    final mockNetworkService = MockNetworkService();

    // // When getPosts is called, return an empty list
    // when(mockNetworkService.getPosts()).thenAnswer((_) => Future.value([]));

    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => mockNetworkService,
        child: Builder(
          builder: (context) => const MaterialApp(
            home: SchedulePosts(),
          ),
        ),
      ),
    );

    // Pump the widget tree to allow the Future to complete
    await tester.pumpAndSettle();

    expect(find.text('Schedule Posts'), findsOneWidget);

    // in case of posts are empty
    // expect(find.text("There aren't any scheduled posts in"), findsOneWidget);
    // expect(find.text("r/{} yet"), findsOneWidget);
  });
}