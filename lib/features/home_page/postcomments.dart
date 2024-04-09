import 'package:flutter/material.dart';
import 'package:reddit_clone/features/home_page/post.dart';

class PostComments extends StatelessWidget {
  final String communityName;
  final String userName;
  final String title;
  final String imageUrl;
  final String content;
  final int commentNumber;
  final int shareNumber;
  final DateTime timeStamp;
  final String profilePicture;
  final bool isHomePage;
  final String postId;
  final bool isDownvoted;
  final bool isUpvoted;
  int votes;

  PostComments({
    super.key,
    required this.communityName,
    required this.userName,
    required this.title,
    required this.imageUrl,
    required this.profilePicture,
    required this.content,
    required this.commentNumber,
    required this.shareNumber,
    required this.timeStamp,
    required this.isHomePage,
    required this.postId,
    required this.votes,
    required this.isDownvoted,
    required this.isUpvoted,
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
          imageUrl: imageUrl,
          content: content,
          commentNumber: commentNumber,
          shareNumber: shareNumber,
          timeStamp: timeStamp,
          isHomePage: isHomePage,
          postId: postId,
          votes: votes,
          isDownvoted: isDownvoted,
          isUpvoted: isUpvoted,
        ),
      ],
    );
  }
}
