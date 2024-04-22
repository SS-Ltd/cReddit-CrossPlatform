import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'dart:async';
import '../../new_page.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:reddit_clone/utils/utils_time.dart';

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
  List<PollsOption>? pollOptions;
  final int shareNumber;
  final DateTime timeStamp;
  final bool isHomePage;
  final bool isSubRedditPage;
  bool isUpvoted;
  bool isDownvoted;

  Post({
    Key? key,
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
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _controllerInitialized =
      false; // Flag to track if controller is initialized

  @override
  void initState() {
    super.initState();
    if (isVideo(widget.content) && widget.postType == 'Images & Video') {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.content));
      _initializeVideoPlayerFuture = _videoController.initialize();
      _videoController.setLooping(true); // Optionally, loop the video.
      _initializeVideoPlayerFuture.then((_) {
        if (mounted) {
          // Check if the widget is still in the tree
          setState(() {
            _controllerInitialized = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (_controllerInitialized) {
      _videoController.dispose();
    }
    super.dispose();
  }

  Widget _buildContent() {
    switch (widget.postType) {
      case ("Images & Video"):
        return Column(
          children: [
            if (isImage(widget.content))
              Image.network(
                widget.content,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else if (isVideo(widget.content))
              _controllerInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_videoController),
                          _ControlsOverlay(
                              controller: _videoController), // Controls overlay
                          VideoProgressIndicator(_videoController,
                              allowScrubbing: true),
                        ],
                      ),
                    )
                  : Container(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
          ],
        );
      case ('Post'):
        return GestureDetector(
          onTap: widget.isHomePage
              ? () {
                  Post postComment = Post(
                    communityName: widget.communityName,
                    profilePicture: widget.profilePicture,
                    userName: widget.userName,
                    title: widget.title,
                    postType: widget.postType,
                    content: widget.content,
                    commentNumber: widget.commentNumber,
                    pollOptions: widget.pollOptions,
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
                        postTitle: widget.title,
                        username: widget.userName,
                      ),
                    ),
                  );
                }
              : null,
          child: widget.isHomePage
              ? Semantics(
                  identifier: 'PostContent',
                  label: "Post Content",
                  child: (Text(
                    widget.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )),
                )
              : (!widget.isHomePage
                  ? Text(widget.content)
                  : const SizedBox.shrink()),
        );
      case ('Poll'):
        if (widget.pollOptions == null) {
          return const SizedBox.shrink();
        } else {
          bool voted = false;
          for (PollsOption option in widget.pollOptions!) {
            if (option.isVoted == true) {
              voted = true;
            }
          }
          return FlutterPolls(
            hasVoted: false,
            pollId: widget.postId,
            onVoted: (PollOption pollOption, int newTotalVotes) async {
              print(
                  'Voted on option: ${pollOption.id} with new total votes: $newTotalVotes');
              bool success =
                  await Provider.of<NetworkService>(context, listen: false)
                      .voteOnPoll(widget.postId, pollOption.id ?? '');
              return success;
            },
            pollOptionsSplashColor: Colors.white,
            votedProgressColor: Colors.grey.withOpacity(0.3),
            votedBackgroundColor: Colors.grey.withOpacity(0.2),
            pollTitle: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            pollOptions: widget.pollOptions!
                .map(
                  (e) => PollOption(
                    id: e.option,
                    title: Text(
                        "${e.option} (${e.votes} votes)"), // Displaying the vote count beside each option
                    votes: e.votes ?? 0,
                  ),
                )
                .toList(),
          );
        }
      case ('Link'):
        return GestureDetector(
          onTap: () async {
            if (await canLaunch(widget.content)) {
              await launch(widget.content);
            } else {
              throw 'Could not launch $widget.content';
            }
          },
          child: Text(
            widget.content,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
        );
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
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => SubRedditPage(
                    //                 subredditName: widget.communityName,
                    //               )),
                    //     );
                    //   },
                    //   child: CircleAvatar(
                    //     backgroundImage: NetworkImage(widget.profilePicture),
                    //   ),
                    // ),
                    //const SizedBox(width: 10),
                    widget.isHomePage
                        ? (widget.isSubRedditPage
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AboutUserPopUp(
                                            userName: widget.userName);
                                      });
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(widget.profilePicture),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'u/${widget.userName}',
                                      style: const TextStyle(
                                        color: Palette.whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      formatTimestamp(widget.timeStamp),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : (widget.communityName.isEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AboutUserPopUp(
                                                userName: widget.userName);
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget.profilePicture),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'u/${widget.userName}',
                                          style: const TextStyle(
                                            color: Palette.whiteColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formatTimestamp(widget.timeStamp),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
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
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              widget.profilePicture),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'r/${widget.communityName}',
                                          style: const TextStyle(
                                            color: Palette.whiteColor,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          formatTimestamp(widget.timeStamp),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )))
                        : (widget.communityName.isEmpty
                            ? GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AboutUserPopUp(
                                            userName: widget.userName);
                                      });
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(widget.profilePicture),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'u/${widget.userName}',
                                      style: const TextStyle(
                                        color: Palette.whiteColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      formatTimestamp(widget.timeStamp),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(widget.profilePicture),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubRedditPage(
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
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AboutUserPopUp(
                                                    userName: widget.userName);
                                              });
                                          //replace with profile page or widget
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              'u/${widget.userName}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              formatTimestamp(widget.timeStamp),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.isHomePage
                ? () {
                    Post postComment = Post(
                      communityName: widget.communityName,
                      profilePicture: widget.profilePicture,
                      userName: widget.userName,
                      title: widget.title,
                      postType: widget.postType,
                      pollOptions: widget.pollOptions,
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
                          postTitle: widget.title,
                          username: widget.userName,
                        ),
                      ),
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: _buildContent(),
          ),
          Row(
            children: [
              Semantics(
                identifier: 'post Upvote',
                label: 'post Upvote',
                child: IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  color: widget.isUpvoted ? Colors.red : Colors.grey,
                  onPressed: () async {
                    int oldVotes = widget.votes;
                    bool oldIsUpVoted = widget.isUpvoted;
                    bool oldIsDownVoted = widget.isDownvoted;
                    if (mounted) {
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
                    }
                    bool upVoted = await context
                        .read<NetworkService>()
                        .upVote(widget.postId);
                    if (!upVoted && mounted) {
                      setState(() {
                        widget.votes = oldVotes;
                        widget.isUpvoted = oldIsUpVoted;
                        widget.isDownvoted = oldIsDownVoted;
                      });
                    }
                  },
                ),
              ),
              Semantics(
                identifier: 'post votes',
                label: 'post votes',
                child: Text(widget.votes.toString(),
                    style: TextStyle(
                      color: widget.isUpvoted
                          ? Colors.red
                          : (widget.isDownvoted ? Colors.blue : Colors.grey),
                    )),
              ),
              Semantics(
                identifier: 'post Downvote',
                label: 'post Downvote',
                child: IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  color: widget.isDownvoted ? Colors.blue : Colors.grey,
                  onPressed: () async {
                    int oldVotes = widget.votes;
                    bool oldIsUpVoted = widget.isUpvoted;
                    bool oldIsDownVoted = widget.isDownvoted;
                    if (mounted) {
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
                    }
                    bool downVoted = await context
                        .read<NetworkService>()
                        .downVote(widget.postId);
                    if (!downVoted && mounted) {
                      setState(() {
                        widget.votes = oldVotes;
                        widget.isUpvoted = oldIsUpVoted;
                        widget.isDownvoted = oldIsDownVoted;
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                //other icon: add_comment,comment
                onPressed: widget.isHomePage
                    ? () {
                        Post postComment = Post(
                          communityName: widget.communityName,
                          profilePicture: widget.profilePicture,
                          userName: widget.userName,
                          title: widget.title,
                          postType: widget.postType,
                          content: widget.content,
                          pollOptions: widget.pollOptions,
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
                              postTitle: widget.title,
                              username: widget.userName,
                            ),
                          ),
                        );
                      }
                    : null,
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

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return Stack(
          children: <Widget>[
            AnimatedSwitcher(
              duration: Duration(milliseconds: 50),
              reverseDuration: Duration(milliseconds: 200),
              child: value.isPlaying
                  ? SizedBox.shrink()
                  : Container(
                      color: Colors.black26,
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50.0,
                          semanticLabel: 'Play',
                        ),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () {
                value.isPlaying ? controller.pause() : controller.play();
              },
            ),
          ],
        );
      },
    );
  }
}
