import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/comments/comment_post.dart';
import 'package:reddit_clone/services/networkServices.dart';

void main() {
  testWidgets('CommentPostPage has a title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkService>(
        create: (_) => MockNetworkService(),
        child: const MaterialApp(
          home: CommentPostPage(
            commentContent: 'Test Comment',
            postId: '1',
          ),
        ),
      ),
    );

    // Verify that our CommentPostPage has a title.
    expect(find.text('Add comment'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
    expect(find.text('Test Comment'), findsOneWidget);

    // Verify that the text field is initially empty
    expect(find.widgetWithText(TextField, ''), findsOneWidget);

    // Simulate entering text into the text field
    await tester.enterText(find.byType(TextField), 'Test Reply');
    await tester.pump();

    // Verify that the entered text is displayed in the text field
    expect(find.widgetWithText(TextField, 'Test Reply'), findsOneWidget);

    // Simulate tapping the "Post" button
    await tester.tap(find.widgetWithText(TextButton, 'Post'));
    await tester.pump();
  });
}
