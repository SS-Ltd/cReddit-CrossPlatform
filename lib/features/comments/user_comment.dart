import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/models/user.dart';
import 'static_comment_card.dart';
import 'reply_comment.dart';
import 'dart:async';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/comments/edit_comment.dart';
import 'package:reddit_clone/models/comments.dart';

class UserComment extends StatefulWidget {
  final String avatar;
  final String username;
  String content;
  final int level;
  final DateTime timestamp;
  File? photo;
  final bool contentType;
  final int netVote;
  int imageSource; //0 from backend 1 from user 2 text
  final String commentId;
  final int hasVoted; // 1 for upvote, -1 for downvote, 0 for no vote
  bool isSaved;

  final Comments comment;
  //for saved comments
  final String communityName;
  final String postId; //
  final String title; //

  UserComment({
    super.key,
    // may be the required keyword need to be removed
    required this.avatar,
    required this.username,
    this.content = '',
    this.level = 0,
    required this.timestamp,
    this.photo,
    required this.contentType,
    this.netVote = 1,
    required this.imageSource,
    required this.commentId,
    required this.hasVoted,
    required this.isSaved,
    this.communityName = '',
    this.postId = '',
    this.title = '',
    required this.comment,
  });

  @override
  UserCommentState createState() => UserCommentState();
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    canvas.drawLine(const Offset(3, 0), Offset(3, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class UserCommentState extends State<UserComment> {
  late int votes;
  late ValueNotifier<int> hasVoted;
  Timer? _timer;
  List<UserComment> replies = [];
  late ValueNotifier<bool> isMinimized;
  late ValueNotifier<String> content;
  late ValueNotifier<File?> photo;

  void _addReply() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReplyPage(
          commentContent: widget.comment.content,
          username: widget.comment.username,
          timestamp: widget.timestamp,
        ),
      ),
    );

    if (result != null) {
      final bool contentType = result['contentType'];

      // if (contentType == false) {
      //   final String commentText = result['content'];
      //   replies.add(UserComment(
      //     avatar: 'assets/MonkeyDLuffy.png',
      //     username: 'User123',
      //     content: commentText,
      //     timestamp: DateTime.now(),
      //     photo: null,
      //     contentType: contentType,
      //     imageSource: 2,
      //     commentId: widget.comment.commentId, //may need to be updated
      //     hasVoted: 0,
      //     isSaved: false,
      //   ));
      // } else if (contentType == true) {
      //   final File commentImage = File(result['content']);
      //   replies.add(UserComment(
      //     avatar: 'assets/MonkeyDLuffy.png',
      //     username: 'User123',
      //     content: '',
      //     timestamp: DateTime.now(),
      //     photo: commentImage,
      //     contentType: contentType,
      //     imageSource: 1,
      //     commentId: widget.comment.commentId, //may need to be updated
      //     hasVoted: 0,
      //     isSaved: false,
          
      //   ));
      // }
    }
  }

  void updateUpVote() {
    if (hasVoted.value == 1) {
      votes--;
      hasVoted.value = 0;
    } else if (hasVoted.value == -1) {
      votes += 2;
      hasVoted.value = 1;
    } else if (hasVoted.value != 1) {
      votes++;
      hasVoted.value = 1;
    }
  }

  void updateDownVote() {
    if (hasVoted.value == -1) {
      votes++;
      hasVoted.value = 0;
    } else if (hasVoted.value == 1) {
      votes -= 2;
      hasVoted.value = -1;
    } else if (hasVoted.value != -1) {
      votes--;
      hasVoted.value = -1;
    }
  }

  @override
  void initState() {
    super.initState();
    isMinimized = ValueNotifier<bool>(false);
    votes = widget.comment.netVote;
    hasVoted = ValueNotifier<int>(widget.hasVoted);
    content = ValueNotifier<String>(widget.content);
    photo = ValueNotifier<File?>(widget.photo);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    hasVoted.dispose();
    content.dispose();
    photo.dispose();
    isMinimized.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isMinimized.value = !isMinimized.value;
            });
          },
          child: Card(
            color: const Color.fromARGB(255, 12, 12, 12),
            shape: Border.all(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(height: 55),
                      if (widget.comment.communityName == '') ...[
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AboutUserPopUp(
                                      userName: widget.comment.username);
                                });
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(widget.comment.profilePicture),
                            //radius: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AboutUserPopUp(
                                      userName: widget.comment.username);
                                });
                          },
                          child: Text(
                            widget.comment.username,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          formatTimestamp(widget.timestamp),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ] else ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Aligns the text to the start of the axis
                            children: <Widget>[
                              Text(
                                widget.comment.title ?? '',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow
                                    .ellipsis, // This will fade the text at the end if it is longer than one line.
                                maxLines:
                                    1, // The max number of lines the text can occupy.
                              ),
                              const SizedBox(
                                  height:
                                      4), // Provides spacing of 4 logical pixels between title and username/community.
                              Text(
                                '${widget.comment.username} . r/${widget.comment.communityName}  .  ${formatTimestamp(DateTime.parse(widget.comment.createdAt))}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                      if (isMinimized.value) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: widget.comment.isImage == false
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: ValueListenableBuilder<String>(
                                      valueListenable: content,
                                      builder: (context, value, child) {
                                        return Text(
                                          value.split('\n')[0],
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : widget.comment.isImage == true &&
                                        widget.imageSource == 0
                                    ? Center(
                                        child: ValueListenableBuilder<String>(
                                          valueListenable: content,
                                          builder: (context, value, child) {
                                            return Image.network(
                                              value,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      )
                                    : widget.comment.isImage == true &&
                                            widget.imageSource == 1
                                        ? Center(
                                            child:
                                                ValueListenableBuilder<File?>(
                                              valueListenable: photo,
                                              builder: (context, value, child) {
                                                if (value != null) {
                                                  return Image.file(
                                                    value,
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return Container(); // return an empty container when the file is null
                                                }
                                              },
                                            ),
                                          )
                                        : Container(),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!isMinimized.value) ...[
                    //const SizedBox(height: 10),
                    if (widget.comment.isImage == false) ...[
                      ValueListenableBuilder<String>(
                        valueListenable: content,
                        builder: (context, value, child) {
                          return Text(
                            value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ] else if (widget.comment.isImage == true &&
                        widget.imageSource == 0) ...[
                      ValueListenableBuilder<String>(
                        valueListenable: content,
                        builder: (context, value, child) {
                          return Image.network(
                            value,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ] else if (widget.comment.isImage == true &&
                        widget.imageSource == 1) ...[
                      ValueListenableBuilder<File?>(
                        valueListenable: photo,
                        builder: (context, value, child) {
                          if (value != null) {
                            return Image.file(
                              value,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Container(); // return an empty container when the file is null
                          }
                        },
                      )
                    ],
                    //const SizedBox(height: 5),
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            UserModel user =
                                context.read<NetworkService>().getUser();
                            int numofTiles;
                            numofTiles =
                                (widget.comment.username == user.username) ? 8 : 7;
                            showCommentOptions(user, numofTiles);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.reply_sharp),
                          onPressed: _addReply,
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return Semantics(
                              identifier: 'comment upvote',
                              label: 'comment upvote',
                              child: IconButton(
                                icon: Icon(Icons.arrow_upward,
                                    color: value == 1
                                        ? Palette.upvoteOrange
                                        : Palette.greyColor),
                                onPressed: () async {
                                  bool votedUp = await context
                                      .read<NetworkService>()
                                      .upVote(widget.comment.commentId);
                                  if (votedUp && mounted) {
                                    setState(() {
                                      updateUpVote();
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return Semantics(
                              identifier: 'comment votes',
                              label: 'comment votes',
                              child: Text(
                                votes == 0 ? 'Vote' : '$votes',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: value == 1
                                        ? Palette.upvoteOrange
                                        : value == -1
                                            ? Palette.downvoteBlue
                                            : Palette.greyColor),
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return Semantics(
                              identifier: 'comment downvote',
                              label: 'comment downvote',
                              child: IconButton(
                                icon: Icon(Icons.arrow_downward,
                                    color: value == -1
                                        ? Palette.downvoteBlue
                                        : Palette.greyColor),
                                onPressed: () async {
                                  bool votedDown = await context
                                      .read<NetworkService>()
                                      .downVote(widget.comment.commentId);
                                  if (votedDown && mounted) {
                                    setState(() {
                                      updateDownVote();
                                    });
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: isMinimized,
          builder: (context, value, child) {
            if (value) {
              return Container();
            } else {
              return Column(
                children: replies.map((reply) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CustomPaint(
                      painter: LinePainter(),
                      child: reply,
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }

  void showCommentOptions(UserModel user, int numofTiles) {
    double height = numofTiles * 56;

    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 8,
        right: 8,
        bottom: height,
        child: Material(
            color: Colors.transparent,
            child: ValueListenableBuilder<String>(
              valueListenable: content,
              builder: (context, contentValue, child) {
                return ValueListenableBuilder<File?>(
                  valueListenable: photo,
                  builder: (context, photoValue, child) {
                    return StaticCommentCard(
                      avatar: widget.comment.profilePicture,
                      username: widget.comment.username,
                      timestamp: widget.timestamp,
                      content: contentValue,
                      contentType: widget.comment.isImage,
                      photo: photoValue,
                      imageSource: widget.imageSource,
                    );
                  },
                );
              },
            )),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (widget.comment.username == user.username)
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit comment'),
                  onTap: () async {
                    Navigator.pop(context);
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCommentPage(
                          commentId: widget.comment.commentId,
                          commentContent: widget.content,
                          contentType: widget.comment.isImage,
                          photo: widget.comment.isImage ? File(widget.comment.content) : null,
                          imageSource: widget.imageSource,
                        ),
                      ),
                    );
                    if (result != null) {
                      final bool contentType = result['contentType'];
                      print(result);
                      setState(() {
                        if (contentType == false) {
                          content.value = result['content'];
                        } else if (contentType == true &&
                            result['imageSource'] == 0) {
                          content.value = result['content'];
                        } else if (contentType == true &&
                            result['imageSource'] == 1) {
                          photo.value = result['content'];
                          widget.imageSource = 1;
                        }
                      });
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: Text(widget.isSaved ? 'Unsave' : 'Save'),
                onTap: () async {
                  bool saved = await context
                      .read<NetworkService>()
                      .saveOrUnsaveComment(widget.comment.commentId, !widget.isSaved);
                  if (saved) {
                    CustomSnackBar(
                      context: context,
                      content: widget.isSaved
                          ? 'Comment Unsaved!'
                          : 'Comment Saved!',
                    ).show();
                    widget.isSaved = !widget.isSaved;
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Get reply notification'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('Copy text'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.merge_type_outlined),
                title: const Text('Collapse thread'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (widget.comment.username == user.username)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete comment'),
                  onTap: () async {
                    bool deleted = await context
                        .read<NetworkService>()
                        .deleteComment(widget.comment.commentId);
                    if (deleted) {
                      CustomSnackBar(
                        context: context,
                        content: 'Comment Deleted!',
                      ).show();
                      Navigator.pop(context);
                    } else {
                      CustomSnackBar(
                        context: context,
                        content: 'Failed to delete comment!',
                      ).show();
                    }
                  },
                ),
              if (widget.comment.username != user.username)
                ListTile(
                  leading: const Icon(Icons.block_outlined),
                  title: const Text('Block account'),
                  onTap: () async {
                    // bool blocked = await context
                    //     .read<NetworkService>()
                    //     .blockUser(widget.comment.username);
                    // if (blocked) {
                    //   CustomSnackBar(
                    //       context: context, content: 'User blocked!');
                    // } else {
                    //   CustomSnackBar(
                    //       context: context, content: 'User unblocked!');
                    // }
                    Navigator.pop(context);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Report'),
                onTap: () async {
                  bool reported = await context
                      .read<NetworkService>()
                      .reportPost(widget.comment.commentId);
                  if (reported) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    ).then((_) {
      // Remove the overlay entry after the modal bottom sheet is dismissed
      overlayEntry.remove();
    });
  }
}

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays > 365) {
    return '${difference.inDays ~/ 365}y';
  } else if (difference.inDays > 30) {
    return '${difference.inDays ~/ 30}m';
  } else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}m';
  } else {
    return '${difference.inSeconds}s';
  }
}
