import 'dart:io';
import 'package:flutter/material.dart';
import 'static_comment_card.dart';
import 'reply_comment.dart';
import 'dart:async';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

class UserComment extends StatefulWidget {
  final String avatar;
  final String username;
  final String content;
  final int level;
  final DateTime timestamp;
  final File? photo;
  final bool contentType;
  final int netVote;
  final int imageSource; //0 from backend 1 from user 2 text
  final String commentId;
  final int hasVoted; // 1 for upvote, -1 for downvote, 0 for no vote

  const UserComment({
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

  void _addReply() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReplyPage(
          commentContent: widget.content,
          username: widget.username,
          timestamp: widget.timestamp,
        ),
      ),
    );

    if (result != null) {
      final bool contentType = result['contentType'];

      if (contentType == false) {
        final String commentText = result['content'];
        replies.add(UserComment(
          avatar: 'assets/MonkeyDLuffy.png',
          username: 'User123',
          content: commentText,
          timestamp: DateTime.now(),
          photo: null,
          contentType: contentType,
          imageSource: 2,
          commentId: widget.commentId, //may need to be updated
          hasVoted: 0,
        ));
      } else if (contentType == true) {
        final File commentImage = File(result['content']);
        replies.add(UserComment(
          avatar: 'assets/MonkeyDLuffy.png',
          username: 'User123',
          content: '',
          timestamp: DateTime.now(),
          photo: commentImage,
          contentType: contentType,
          imageSource: 1,
          commentId: widget.commentId, //may need to be updated
          hasVoted: 0,
        ));
      }
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
    votes = widget.netVote;
    hasVoted = ValueNotifier<int>(widget.hasVoted);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    hasVoted.dispose();
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
                      GestureDetector(
                        onTap: () {
                          // will be replaced with redirecting to user
                          //showOverlay(context, widget);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutUserPopUp()),
                            //replace with profile page or widget
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.avatar),
                          //radius: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // will be replaced with redirecting to user
                          //showOverlay(context, widget);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutUserPopUp()),
                            //replace with profile page or widget
                          );
                        },
                        child: Text(
                          widget.username,
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
                      if (isMinimized.value) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: widget.contentType == false
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.content.split('\n')[0],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  )
                                : widget.contentType == true &&
                                        widget.imageSource == 0
                                    ? Center(
                                        child: Image.network(
                                          widget.content,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : widget.contentType == true &&
                                            widget.imageSource == 1
                                        ? Center(
                                            child: Image.file(
                                              widget.photo!,
                                              fit: BoxFit.cover,
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
                    if (widget.contentType == false) ...[
                      Text(
                        widget.content,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ] else if (widget.contentType == true &&
                        widget.imageSource == 0) ...[
                      Image.network(
                        widget.content,
                        fit: BoxFit.cover,
                      ),
                    ] else if (widget.contentType == true &&
                        widget.imageSource == 1) ...[
                      Image.file(
                        widget.photo!,
                        fit: BoxFit.cover,
                      ),
                    ],
                    //const SizedBox(height: 5),
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showOverlay(context, widget ,7);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.reply_sharp),
                          onPressed: _addReply,
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return IconButton(
                              icon: Icon(Icons.arrow_upward,
                                  color: value == 1
                                      ? Palette.upvoteOrange
                                      : Palette.greyColor),
                              onPressed: () async {
                                bool votedUp = await context
                                    .read<NetworkService>()
                                    .upVote(widget.commentId);
                                if (votedUp && mounted) {
                                  setState(() {
                                    updateUpVote();
                                  });
                                }
                              },
                            );
                          },
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return Text(
                              votes == 0 ? 'Vote' : '$votes',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: value == 1
                                      ? Palette.upvoteOrange
                                      : value == -1
                                          ? Palette.downvoteBlue
                                          : Palette.greyColor),
                            );
                          },
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return IconButton(
                              icon: Icon(Icons.arrow_downward,
                                  color: value == -1
                                      ? Palette.downvoteBlue
                                      : Palette.greyColor),
                              onPressed: () async {
                                bool votedDown = await context
                                    .read<NetworkService>()
                                    .downVote(widget.commentId);
                                if (votedDown && mounted) {
                                  setState(() {
                                    updateDownVote();
                                  });
                                }
                              },
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

void showOverlay(BuildContext context, UserComment card ,int numOfTiles) {
  double height = numOfTiles * 56;
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      left: 8,
      right: 8,
      bottom: height,
      child: Material(
        color: Colors.transparent,
        child: StaticCommentCard(
          avatar: card.avatar,
          username: card.username,
          timestamp: card.timestamp,
          content: card.content,
          contentType: card.contentType,
          photo: card.photo,
          imageSource: card.imageSource,
        ),
      ),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromARGB(255, 19, 19, 19),
    builder: (context) {
      return Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: const Text('Save'),
            onTap: () {
              Navigator.pop(context);
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
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: const Text('Block account'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Report'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((_) {
    // Remove the overlay entry after the modal bottom sheet is dismissed
    overlayEntry.remove();
  });
}
