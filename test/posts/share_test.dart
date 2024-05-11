import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/features/settings/account_settings.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/post/share.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/features/settings/manage_blocked_accounts.dart';
import 'package:reddit_clone/features/home_page/post.dart';

void main() {
  testWidgets('Share widget test', (WidgetTester tester) async {
    final mockPost = PostModel(
      title: 'Test Post',
      content: 'Hello there!',
      postId: '',
      type: 'Post',
      username: 'username',
      communityName: 'communityname',
      pollOptions: [],
      expirationDate: null,
      netVote: 0,
      isSpoiler: false,
      isLocked: false,
      isApproved: false,
      isEdited: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      profilePicture: 'assets/hehe.png',
      commentCount: 0,
      isDeletedUser: false,
      isUpvoted: false,
      isDownvoted: false,
      isSaved: false,
      isHidden: false,
      isNSFW: false,
    ); 

    await tester.pumpWidget(MaterialApp(home: Share(post: mockPost, communityName: "My Profile")));

    expect(find.text('Post'), findsOneWidget);
    expect(find.text("Crosspost"), findsOneWidget);
  });
}