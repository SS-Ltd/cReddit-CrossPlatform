import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/post/create_post.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('Create Post Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: CreatePost(profile : true),
        ),
      ),
    );

    Finder title = find.byKey(const Key('title'));
    expect(title, findsOneWidget);
    await tester.enterText(title, '12345678aaA');
    expect(find.text('12345678aaA'), findsOneWidget);

    Finder newpassword = find.byKey(const Key('body'));
    expect(newpassword, findsOneWidget);
    await tester.enterText(newpassword, 'kjasndkjanskdjnaskljdnKAS');
    expect(find.text('kjasndkjanskdjnaskljdnKAS'), findsOneWidget);

    Finder post = find.byKey(const Key('PostButton'));
    await tester.tap(post);


  });
}
