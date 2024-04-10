import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';

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
    Key? key,
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
  }) : super(key: key);

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
