import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/MockNetworkService.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:flutter_polls/flutter_polls.dart'; // For testing polls
import 'package:video_player/video_player.dart'; // For testing video player
import 'package:url_launcher/url_launcher.dart'; // For testing external links

PostModel createDefaultPostModel() {
  return PostModel(
    title: 'Test Post',
    content: 'Hello there',
    postId: '1234',
    type: 'Post',
    username: 'username',
    communityName: 'communityname',
    netVote: 0,
    createdAt: DateTime.now(),
    commentCount: 0,
    profilePicture: 'assets/hehe.png',
    pollOptions: [],
    expirationDate: null,
    isNSFW: false,
    isSpoiler: false,
    isLocked: false,
    isApproved: false,
    isEdited: false,
    updatedAt: DateTime.now(),
    isDeletedUser: false,
    isUpvoted: false,
    isDownvoted: false,
    isSaved: false,
    isHidden: false,
  );
}

void main() {
  // testWidgets('Post with image content', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '1234',
  //             type: 'Images & Video',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: 'assets/hehe.png',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.byType(Image), findsOneWidget); // Ensure image is displayed
  // });

  // testWidgets('Post with video content', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: 'assets/hehe.png',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.byType(VideoPlayer), findsOneWidget); // Ensure video is displayed
  // });

  // testWidgets('Post with poll content', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: 'assets/hehe.png',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.byType(FlutterPolls), findsOneWidget); // Ensure poll is displayed
  // });

  // testWidgets('Post with NSFW flag', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: 'assets/hehe.png',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.text('NSFW'), findsOneWidget); // Ensure NSFW warning is displayed
  // });

  // testWidgets('Post with spoiler flag', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: '',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.text('Spoiler'), findsOneWidget); // Ensure spoiler warning is displayed
  // });

/*********************************************************************************************************************** */

  // testWidgets('Post with "save" functionality', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: '',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   // Test saving a post
  //   expect(find.byIcon(Icons.bookmark), findsOneWidget); // Ensure save icon is displayed
  //   await tester.tap(find.byIcon(Icons.bookmark)); // Tap the save icon
  //   await tester.pumpAndSettle();
  //   expect(find.text('Saved'), findsOneWidget); // Ensure post is marked as saved
  // });

  // testWidgets('Post with "hidden" functionality', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //        home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: '',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

  //   expect(find.text('This post is hidden'), findsOneWidget); // Ensure hidden warning is displayed
  // });

  // testWidgets('Post with moderator actions', (WidgetTester tester) async {
  //   await tester.pumpWidget(
  //     ChangeNotifierProvider<NetworkService>(
  //       create: (_) => MockNetworkService(),
  //       child: MaterialApp(
  //         home: Post(
  //           postModel: PostModel(
  //             title: 'Moderator Post',
  //             content: 'Moderator content',
  //             postId: '',
  //             type: 'Post',
  //             username: 'username',
  //             communityName: 'communityname',
  //             netVote: 0,
  //             createdAt: DateTime.now(),
  //             commentCount: 0,
  //             profilePicture: '',
  //             isModerator: true,
  //             isNSFW: false,
  //             isSpoiler: false,
  //             isLocked: false,
  //             isApproved: false,
  //             isEdited: false,
  //             isUpvoted: false,
  //             isDownvoted: false,
  //             isSaved: false,
  //             isHidden: false,
  //             pollOptions: [],
  //             expirationDate: null,
  //             updatedAt: DateTime.now(),
  //             isDeletedUser: false,
  //           ),
  //           isSubRedditPage: false,
  //         ),
  //       ),
  //     ),
  //   );

  //   await tester.pumpAndSettle();

    // expect(find.byIcon(Icons.shield_outlined), findsOneWidget); // Ensure moderator icon is displayed

    // Test opening the moderator pop-up
    // await tester.tap(find.byIcon(Icons.shield_outlined)); // Tap moderator icon
    // await tester.pumpAndSettle();

    // Adjust assertion based on what appears in the pop-up
    // expect(find.text('Moderator Settings'), findsOneWidget); // If this is part of the pop-up content
  // }
  // );
}