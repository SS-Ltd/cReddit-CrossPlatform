import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';

/// Represents a widget that displays the comments section for a post.
///
/// This widget is responsible for rendering the comments section for a post,
/// including the post itself and any associated comments. It takes in various
/// properties such as the community name, user name, post title, post type,
/// content, comment number, share number, timestamp, profile picture, and
/// voting information.
///
/// The [PostComments] widget is typically used within the context of a
/// [Column] widget to display the comments section vertically.
class PostComments extends StatelessWidget {
  final String communityName;
  final String userName;
  final String title;
  final String postType;
  final String content;
  final int commentNumber;
  final int shareNumber;
  final DateTime timeStamp;
  final String profilePicture;
  final bool isHomePage;
  final bool isSubRedditPage;
  final String postId;
  final bool isDownvoted;
  final bool isUpvoted;
  final List<PollsOption>? pollOptions;
  int votes;

  PostComments({
    super.key,
    required this.communityName,
    required this.userName,
    required this.title,
    required this.postType,
    required this.profilePicture,
    required this.content,
    required this.commentNumber,
    required this.shareNumber,
    required this.timeStamp,
    required this.isHomePage,
    required this.isSubRedditPage,
    required this.postId,
    required this.votes,
    required this.isDownvoted,
    required this.isUpvoted,
    this.pollOptions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Post(
          communityName: communityName,
          userName: userName,
          title: title,
          profilePicture: profilePicture,
          postType: postType,
          content: content,
          commentNumber: commentNumber,
          pollOptions: pollOptions,
          shareNumber: shareNumber,
          timeStamp: timeStamp,
          isHomePage: isHomePage,
          isSubRedditPage: isSubRedditPage,
          postId: postId,
          votes: votes,
          isDownvoted: isDownvoted,
          isUpvoted: isUpvoted,
        ),
      ],
    );
  }
}
