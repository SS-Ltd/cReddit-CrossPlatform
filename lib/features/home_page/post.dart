import 'package:flutter/material.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'dart:async';
import '../../new_page.dart';
import 'package:reddit_clone/features/home_page/postcomments.dart';

class Post extends StatefulWidget {
  final String communityName;
  final String userName;
  final String title;
  final String profilePicture;
  final String imageUrl;
  final String content;
  final int commentNumber;
  final int shareNumber;
  final DateTime timeStamp;
  final bool isHomePage;
  final String postId;
  final bool isUpvoted;
  final bool isDownvoted;
  int votes;

  Post({
    required this.communityName,
    required this.userName,
    required this.title,
    required this.profilePicture,
    required this.imageUrl,
    required this.content,
    this.commentNumber = 0,
    this.shareNumber = 0,
    required this.timeStamp,
    this.isHomePage = true,
    required this.postId,
    required this.votes,
    required this.isUpvoted,
    required this.isDownvoted,
    super.key,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.profilePicture),
                      ),
                      const SizedBox(width: 10),
                      widget.isHomePage
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubRedditPage(
                                            subredditName: widget.communityName,
                                          )),
                                );
                              },
                              child: Text(
                                'r/${widget.communityName}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'r/${widget.communityName}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AboutUserPopUp()),
                                      //replace with profile page or widget
                                    );
                                  },
                                  child: Text(
                                    'u/${widget.userName} . ${formatTimestamp(widget.timeStamp)}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.isHomePage
                ? () {
                    PostComments postComment = PostComments(
                      communityName: widget.communityName,
                      profilePicture: widget.profilePicture,
                      userName: widget.userName,
                      title: widget.title,
                      imageUrl:
                          'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
                      content: widget.content,
                      commentNumber: widget.commentNumber,
                      shareNumber: widget.shareNumber,
                      timeStamp: widget.timeStamp,
                      isHomePage: false,
                      postId: widget.postId,
                      votes: widget.votes,
                      isDownvoted: widget.isDownvoted,
                      isUpvoted: widget.isUpvoted,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(
                            postId: widget.postId, postComment: postComment),
                      ),
                    );
                  }
                : null,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Visibility(
            visible: widget.imageUrl.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => ImageScreen(imageUrl: widget.imageUrl),
                    builder: (context) => const NewPage(),
                    //replace with image screen
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.isHomePage
                ? () {
                    PostComments postComment = PostComments(
                      communityName: widget.communityName,
                      profilePicture: widget.profilePicture,
                      userName: widget.userName,
                      title: widget.title,
                      imageUrl:
                          'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
                      content: widget.content,
                      commentNumber: widget.commentNumber,
                      shareNumber: widget.shareNumber,
                      timeStamp: widget.timeStamp,
                      isHomePage: false,
                      postId: widget.postId,
                      votes: widget.votes,
                      isDownvoted: widget.isDownvoted,
                      isUpvoted: widget.isUpvoted,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(
                            postId: widget.postId, postComment: postComment),
                      ),
                    );
                  }
                : null,
            child: widget.isHomePage && widget.imageUrl.isEmpty
                ? (Text(
                    widget.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ))
                : (!widget.isHomePage
                    ? Text(widget.content)
                    : const SizedBox.shrink()),
          ),
          // const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () {
                  setState(() {
                    widget.votes++;
                  });
                },
              ),
              Text(widget.votes.toString()),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () {
                  setState(() {
                    widget.votes--;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.add_comment),
                //other icon: add_comment,comment
                onPressed: () {
                  PostComments postComment = PostComments(
                    communityName: widget.communityName,
                    profilePicture: widget.profilePicture,
                    userName: widget.userName,
                    title: widget.title,
                    imageUrl:
                        'https://qph.cf2.quoracdn.net/main-qimg-e0b7b0c38b6cecad120db23705ccc4f3-pjlq',
                    content: widget.content,
                    commentNumber: widget.commentNumber,
                    shareNumber: widget.shareNumber,
                    timeStamp: widget.timeStamp,
                    isHomePage: false,
                    postId: widget.postId,
                    votes: widget.votes,
                    isDownvoted: widget.isDownvoted,
                    isUpvoted: widget.isUpvoted,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(
                          postId: widget.postId, postComment: postComment),
                    ),
                  );
                },
              ),
              Text(widget.commentNumber.toString()),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.ios_share),
                //other icon: ios_share, share
                onPressed: () {
                  // share post
                },
              ),
              if (widget.shareNumber > 0) Text(widget.shareNumber.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return '${difference.inSeconds}s';
  }
}
