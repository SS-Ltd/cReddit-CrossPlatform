import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/comments/static_comment_card.dart';
import 'package:reddit_clone/models/comments.dart';

void main() {
  testWidgets('StaticCommentCard Widget Test', (WidgetTester tester) async {
    // Create a sample comment
    final comment = Comments(
      profilePicture: 'assets/hehe.png',
      username: 'Test User',
      isImage: false,
      netVote: 0,
      content: 'Test Comment',
      createdAt: DateTime.now().toString(),
      commentId: 'testId',
      isUpvoted: false,
      isDownvoted: false,
      isSaved: false,
      communityName: 'Test Community',
      postId: 'testPostId',
      title: 'Test Title',
      isApproved: false,
    );

    // Build the StaticCommentCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StaticCommentCard(
            content: 'Test Comment',
            contentType: false,
            imageSource: 2,
            staticComment: comment,
          ),
        ),
      ),
    );

    // Verify that the StaticCommentCard is displayed
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Test Comment'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);

    // Verify that the Card widget is displayed
    expect(find.byType(Card), findsOneWidget);

    // Verify that the MarkdownBody widget is displayed
    expect(find.byType(MarkdownBody), findsOneWidget);

  });
}