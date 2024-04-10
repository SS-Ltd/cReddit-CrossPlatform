import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'dart:async';
import '../../new_page.dart';
import 'post_comment.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/home_page/postcomments.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:video_player/video_player.dart';

class PollOptions {
  String option;
  bool isVoted;
  int votes;

  PollOptions({
    required this.option,
    required this.isVoted,
    required this.votes,
  });
}

class Post extends StatefulWidget {
  final String postId;
  final String postType;
  final String userName;
  final String communityName;
  final String profilePicture;
  int votes;
  int commentNumber;
  final String title;
  final String content;
  List<PollOptions>? pollOptions;
  final int shareNumber;
  final DateTime timeStamp;
  final bool isHomePage;
  final bool isSubRedditPage;
  bool isUpvoted;
  bool isDownvoted;

  Post({
    required this.communityName,
    required this.userName,
    required this.title,
    required this.profilePicture,
    this.pollOptions,
    required this.postType,
    required this.content,
    this.commentNumber = 0,
    this.shareNumber = 0,
    required this.timeStamp,
    this.isHomePage = true,
    required this.isSubRedditPage,
    required this.postId,
    required this.votes,
    required this.isUpvoted,
    required this.isDownvoted,
    Key? key,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  Timer? _timer;
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (isVideo(widget.content)) {
      _videoController = VideoPlayerController.network(widget.content);
      _initializeVideoPlayerFuture = _videoController.initialize();
      _videoController.setLooping(true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  Widget _buildContent() {
    switch (widget.postType) {
      case ("Images & Video"):
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
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
                  child: isImage(widget.content)
                      ? Image.network(
                          widget.content,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : isVideo(widget.content)
                          ? FutureBuilder(
                              future: _initializeVideoPlayerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return AspectRatio(
                                    aspectRatio:
                                        _videoController.value.aspectRatio,
                                    child: VideoPlayer(_videoController),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            )
                          : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        );
      case ('Post'):
        return GestureDetector(
          onTap: widget.isHomePage
              ? () {
                  PostComments postComment = PostComments(
                    communityName: widget.communityName,
                    profilePicture: widget.profilePicture,
                    userName: widget.userName,
                    title: widget.title,
                    postType: widget.postType,
                    content: widget.content,
                    commentNumber: widget.commentNumber,
                    shareNumber: widget.shareNumber,
                    timeStamp: widget.timeStamp,
                    isHomePage: false,
                    isSubRedditPage: false,
                    postId: widget.postId,
                    votes: widget.votes,
                    isDownvoted: widget.isDownvoted,
                    isUpvoted: widget.isUpvoted,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(
                          postId: widget.postId,
                          postComment: postComment,
                          postTitle: widget.title),
                    ),
                  );
                }
              : null,
          child: widget.isHomePage
              ? (Text(
                  widget.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ))
              : (!widget.isHomePage
                  ? Text(widget.content)
                  : const SizedBox.shrink()),
        );
      // case ('Poll'):
      //   return FlutterPolls(
      //     pollId: widget.postId,
      //     onVoted: (){
      //       print('Voted');
      //     },
      //     pollTitle: Text(widget.content),
      //     pollOptions: widget.pollOptions!.map((option) {
      //         return PollsOptions(
      //           option: option.option,
      //           votes: option.votes,
      //           isVoted: option.isVoted);
      //     }).toList(),
      //   );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Palette.backgroundColor,
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
                          ? (widget.isSubRedditPage
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AboutUserPopUp()),
                                    );
                                  },
                                  child: Text(
                                    'r/${widget.userName}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SubRedditPage(
                                                subredditName:
                                                    widget.communityName,
                                              )),
                                    );
                                  },
                                  child: Text(
                                    'r/${widget.communityName}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ))
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
                      postType: widget.postType,
                      content: widget.content,
                      commentNumber: widget.commentNumber,
                      shareNumber: widget.shareNumber,
                      timeStamp: widget.timeStamp,
                      isHomePage: false,
                      isSubRedditPage: false,
                      postId: widget.postId,
                      votes: widget.votes,
                      isDownvoted: widget.isDownvoted,
                      isUpvoted: widget.isUpvoted,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //builder: (context) => CommentPage(postId: '6614799910f5d8c658ac1681',postComment: postComment),
                        builder: (context) => CommentPage(
                            postId: widget.postId,
                            postComment: postComment,
                            postTitle: widget.title),
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
          _buildContent(),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                color: widget.isUpvoted ? Colors.red : Colors.grey,
                onPressed: () async {
                  bool a = await context
                      .read<NetworkService>()
                      .upVote(widget.postId);
                  setState(() {
                    print("upvote");
                    if (widget.isUpvoted && !widget.isDownvoted) {
                      widget.votes--;
                      widget.isUpvoted = false;
                    } else if (!widget.isUpvoted && widget.isDownvoted) {
                      widget.votes += 2;
                      widget.isUpvoted = true;
                      widget.isDownvoted = false;
                    } else if (!widget.isUpvoted && !widget.isDownvoted) {
                      widget.votes++;
                      widget.isUpvoted = true;
                    }
                  });
                },
              ),
              Text(widget.votes.toString(),
                  style: TextStyle(
                    color: widget.isUpvoted
                        ? Colors.red
                        : (widget.isDownvoted ? Colors.blue : Colors.grey),
                  )),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                color: widget.isDownvoted ? Colors.blue : Colors.grey,
                onPressed: () async {
                  bool a = await context
                      .read<NetworkService>()
                      .downVote(widget.postId);
                  setState(() {
                    if (widget.isDownvoted && !widget.isUpvoted) {
                      widget.votes++;
                      widget.isDownvoted = false;
                    } else if (widget.isUpvoted && !widget.isDownvoted) {
                      widget.votes -= 2;
                      widget.isUpvoted = false;
                      widget.isDownvoted = true;
                    } else if (!widget.isUpvoted && !widget.isDownvoted) {
                      widget.votes--;
                      widget.isDownvoted = true;
                    }
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
                    postType: widget.postType,
                    content: widget.content,
                    commentNumber: widget.commentNumber,
                    shareNumber: widget.shareNumber,
                    timeStamp: widget.timeStamp,
                    isHomePage: false,
                    isSubRedditPage: false,
                    postId: widget.postId,
                    votes: widget.votes,
                    isDownvoted: widget.isDownvoted,
                    isUpvoted: widget.isUpvoted,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => CommentPage(postId: '6614799910f5d8c658ac1681',postComment: postComment),
                      builder: (context) => CommentPage(
                          postId: widget.postId,
                          postComment: postComment,
                          postTitle: widget.title),
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

bool isImage(String url) {
  return url.toLowerCase().endsWith('.jpg') ||
         url.toLowerCase().endsWith('.jpeg') ||
         url.toLowerCase().endsWith('.png') ||
         url.toLowerCase().endsWith('.gif');
}

bool isVideo(String url) {
  return url.toLowerCase().endsWith('.mp4') ||
         url.toLowerCase().endsWith('.webm') ||
         url.toLowerCase().endsWith('.ogg');
}
