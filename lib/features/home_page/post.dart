import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/features/post/choose_community.dart';
import 'package:reddit_clone/features/post/share.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:reddit_clone/utils/utils_time.dart';
import 'package:reddit_clone/features/home_page/moderator_pop_up.dart';

class Post extends StatefulWidget {
  final PostModel postModel;
  final int shareNumber;
  final bool isHomePage;
  final bool isSubRedditPage;

  const Post({
    super.key,
    required this.postModel,
    this.isHomePage = true,
    required this.isSubRedditPage,
    this.shareNumber = 0,
  });

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
    if (isVideo(widget.postModel.content) &&
        widget.postModel.type == 'Images & Video') {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.postModel.content));
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
    switch (widget.postModel.type) {
      case ("Images & Video"):
        return Column(
          children: [
            if (isImage(widget.postModel.content))
              ClipRect(
                child: Stack(
                  children: [
                    Image.network(
                      widget.postModel.content,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (widget.postModel.isSpoiler)
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            else if (isVideo(widget.postModel.content))
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
                  : const SizedBox(
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
                    postModel: widget.postModel,
                    isHomePage: false,
                    isSubRedditPage: false,
                    shareNumber: widget.shareNumber,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentPage(
                        postId: widget.postModel.postId,
                        postComment: postComment,
                        postTitle: widget.postModel.title,
                        username: widget.postModel.username,
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
                    widget.postModel.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )),
                )
              : (!widget.isHomePage
                  ? Text(widget.postModel.content)
                  : const SizedBox.shrink()),
        );
      case ('Poll'):
        if (widget.postModel.pollOptions == null) {
          return const SizedBox.shrink();
        } else {
          bool voted = false;
          for (PollsOption option in widget.postModel.pollOptions!) {
            if (option.isVoted == true) {
              voted = true;
            }
          }
          return FlutterPolls(
            hasVoted: false,
            pollId: widget.postModel.postId,
            onVoted: (PollOption pollOption, int newTotalVotes) async {
              bool success =
                  await Provider.of<NetworkService>(context, listen: false)
                      .voteOnPoll(widget.postModel.postId, pollOption.id ?? '');
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
            pollOptions: widget.postModel.pollOptions!
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
            if (await canLaunch(widget.postModel.content)) {
              await launch(widget.postModel.content);
            } else {
              throw 'Could not launch $widget.content';
            }
          },
          child: Text(
            widget.postModel.content,
            style: const TextStyle(
              color: Colors.blue,
            ),
          ),
        );
      default:
        return const SizedBox.shrink();
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
            color: const Color.fromARGB(255, 12, 12, 12),
            elevation: 0.77,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubRedditPage(
                                      subredditName:
                                          widget.postModel.communityName,
                                    )),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.postModel.profilePicture),
                        ),
                      ),
                      const SizedBox(width: 10),
                      widget.isHomePage
                          ? (widget.isSubRedditPage
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AboutUserPopUp(
                                              userName:
                                                  widget.postModel.username);
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Semantics(
                                        identifier: 'post username',
                                        label: 'post username',
                                        child: Text(
                                          'u/${widget.postModel.username}',
                                          style: const TextStyle(
                                            color: Palette.whiteColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        formatTimestamp(
                                            widget.postModel.createdAt),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : (widget.postModel.communityName.isEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AboutUserPopUp(
                                                  userName: widget
                                                      .postModel.username);
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'u/${widget.postModel.username}',
                                            style: const TextStyle(
                                              color: Palette.whiteColor,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            formatTimestamp(
                                                widget.postModel.createdAt),
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
                                              builder: (context) =>
                                                  SubRedditPage(
                                                    subredditName: widget
                                                        .postModel
                                                        .communityName,
                                                  )),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Semantics(
                                            identifier: 'post subreddit',
                                            label: 'post subreddit',
                                            child: Text(
                                              'r/${widget.postModel.communityName}',
                                              style: const TextStyle(
                                                color: Palette.whiteColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            formatTimestamp(
                                                widget.postModel.createdAt),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )))
                          : (widget.postModel.communityName.isEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AboutUserPopUp(
                                              userName:
                                                  widget.postModel.username);
                                        });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'u/${widget.postModel.username}',
                                        style: const TextStyle(
                                          color: Palette.whiteColor,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        formatTimestamp(
                                            widget.postModel.createdAt),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SubRedditPage(
                                                    subredditName: widget
                                                        .postModel
                                                        .communityName,
                                                  )),
                                        );
                                      },
                                      child: Semantics(
                                        identifier: 'post subreddit',
                                        label: 'post subreddit',
                                        child: Text(
                                          'r/${widget.postModel.communityName}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AboutUserPopUp(
                                                  userName: widget
                                                      .postModel.username);
                                            });
                                        //replace with profile page or widget
                                      },
                                      child: Row(
                                        children: [
                                          Semantics(
                                            identifier: 'post username',
                                            label: 'post username',
                                            child: Text(
                                              'u/${widget.postModel.username}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            formatTimestamp(
                                                widget.postModel.createdAt),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))
                    ],
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.isHomePage
                ? () {
                    Post postComment = Post(
                      postModel: widget.postModel,
                      isHomePage: false,
                      isSubRedditPage: false,
                      shareNumber: widget.shareNumber,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(
                          postId: widget.postModel.postId,
                          postComment: postComment,
                          postTitle: widget.postModel.title,
                          username: widget.postModel.username,
                        ),
                      ),
                    );
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Semantics(
                identifier: 'post title',
                label: 'post title',
                child: Text(
                  widget.postModel.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
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
                  color: widget.postModel.isUpvoted ? Colors.red : Colors.grey,
                  onPressed: () async {
                    int oldVotes = widget.postModel.netVote;
                    bool oldIsUpVoted = widget.postModel.isUpvoted;
                    bool oldIsDownVoted = widget.postModel.isDownvoted;
                    if (mounted) {
                      setState(() {
                        if (widget.postModel.isUpvoted &&
                            !widget.postModel.isDownvoted) {
                          widget.postModel.netVote--;
                          widget.postModel.isUpvoted = false;
                        } else if (!widget.postModel.isUpvoted &&
                            widget.postModel.isDownvoted) {
                          widget.postModel.netVote += 2;
                          widget.postModel.isUpvoted = true;
                          widget.postModel.isDownvoted = false;
                        } else if (!widget.postModel.isUpvoted &&
                            !widget.postModel.isDownvoted) {
                          widget.postModel.netVote++;
                          widget.postModel.isUpvoted = true;
                        }
                      });
                    }
                    bool upVoted = await context
                        .read<NetworkService>()
                        .upVote(widget.postModel.postId);
                    if (!upVoted && mounted) {
                      setState(() {
                        widget.postModel.netVote = oldVotes;
                        widget.postModel.isUpvoted = oldIsUpVoted;
                        widget.postModel.isDownvoted = oldIsDownVoted;
                      });
                    }
                  },
                ),
              ),
              Semantics(
                identifier: 'post votes',
                label: 'post votes',
                child: Text(widget.postModel.netVote.toString(),
                    style: TextStyle(
                      color: widget.postModel.isUpvoted
                          ? Colors.red
                          : (widget.postModel.isDownvoted
                              ? Colors.blue
                              : Colors.grey),
                    )),
              ),
              Semantics(
                identifier: 'post Downvote',
                label: 'post Downvote',
                child: IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  color:
                      widget.postModel.isDownvoted ? Colors.blue : Colors.grey,
                  onPressed: () async {
                    int oldVotes = widget.postModel.netVote;
                    bool oldIsUpVoted = widget.postModel.isUpvoted;
                    bool oldIsDownVoted = widget.postModel.isDownvoted;
                    if (mounted) {
                      setState(() {
                        if (widget.postModel.isDownvoted &&
                            !widget.postModel.isUpvoted) {
                          widget.postModel.netVote++;
                          widget.postModel.isDownvoted = false;
                        } else if (widget.postModel.isUpvoted &&
                            !widget.postModel.isDownvoted) {
                          widget.postModel.netVote -= 2;
                          widget.postModel.isUpvoted = false;
                          widget.postModel.isDownvoted = true;
                        } else if (!widget.postModel.isUpvoted &&
                            !widget.postModel.isDownvoted) {
                          widget.postModel.netVote--;
                          widget.postModel.isDownvoted = true;
                        }
                      });
                    }
                    bool downVoted = await context
                        .read<NetworkService>()
                        .downVote(widget.postModel.postId);
                    if (!downVoted && mounted) {
                      setState(() {
                        widget.postModel.netVote = oldVotes;
                        widget.postModel.isUpvoted = oldIsUpVoted;
                        widget.postModel.isDownvoted = oldIsDownVoted;
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: Semantics(
                    identifier: "post comment",
                    label: "post comment",
                    child: const Icon(Icons.chat_bubble_outline)),
                //other icon: add_comment,comment
                onPressed: widget.isHomePage
                    ? () {
                        Post postComment = Post(
                          postModel: widget.postModel,
                          isHomePage: false,
                          isSubRedditPage: false,
                          shareNumber: widget.shareNumber,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              postId: widget.postModel.postId,
                              postComment: postComment,
                              postTitle: widget.postModel.title,
                              username: widget.postModel.username,
                            ),
                          ),
                        );
                      }
                    : null,
              ),
              Text(widget.postModel.commentCount.toString()),
              const Spacer(),
              if (widget.postModel.isModerator)
                IconButton(
                  icon: const Icon(Icons.shield_outlined),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ModeratorPopUP(postModel: widget.postModel);
                        });
                  },
                ),
              IconButton(
                icon: Semantics(
                    identifier: "post share",
                    label: "post share",
                    child: const Icon(Icons.share)),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BottomSheet(
                            onClosing: () {},
                            builder: (context) => Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 10, 20),
                              child: Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        "Share",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) =>
                                                        ChooseCommunity(
                                                      homePage: true,
                                                      post: widget.postModel,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.share),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                              ),
                                            ),
                                            const Text("Community"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (context) => Share(
                                                      post: widget.postModel,
                                                      communityName:
                                                          "My Profile",
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.reddit),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                              ),
                                            ),
                                            const Text("Profile"),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              icon: const Icon(Icons.link),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.white),
                                              ),
                                            ),
                                            const Text("Copy Link"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
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
  const _ControlsOverlay({super.key, required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        return Stack(
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              reverseDuration: const Duration(milliseconds: 200),
              child: value.isPlaying
                  ? const SizedBox.shrink()
                  : Container(
                      color: Colors.black26,
                      child: const Center(
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
