// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/features/User/report_button.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'static_comment_card.dart';
import 'reply_comment.dart';
import 'dart:async';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/User/about_user_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/comments/edit_comment.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/utils/utils_time.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// This file contains the implementation of the [UserComment] widget and its related classes.
///
/// The [UserComment] widget is a stateful widget that represents a user comment in a comment section.
/// It displays the user's profile picture, username, comment content, and voting buttons.
/// The widget also allows users to reply to the comment and view replies.
///
/// The [LinePainter] class is a custom painter that draws a vertical line on the left side of the comment.
///
/// The [UserCommentState] class is the state class for the [UserComment] widget.
/// It manages the state of the comment, including the number of votes, voting status, replies, and content.
/// The class also handles user interactions such as upvoting, downvoting, adding replies, and minimizing the comment.

class UserComment extends StatefulWidget {
  final int level;
  File? photo;
  int imageSource; //0 from backend 1 from user 2 text
  final int hasVoted; // 1 for upvote, -1 for downvote, 0 for no vote
  final Comments comment;
  final VoidCallback onDeleted;
  final VoidCallback onBlock;
  final bool isPostPage; // true for post, false for savedcomments
  bool isModerator;

  UserComment({
    super.key,
    this.level = 0,
    this.photo,
    required this.imageSource,
    required this.hasVoted,
    required this.comment,
    this.onDeleted = defaultOnDeleted,
    this.onBlock = defaultOnBlock,
    required this.isPostPage,
    this.isModerator = false,
  });

  static void defaultOnDeleted() {}
  static void defaultOnBlock() {}

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
          timestamp: DateTime.parse(widget.comment.createdAt),
        ),
      ),
    );

    if (result != null) {
      final bool contentType = result['contentType'];

      if (contentType == false) {
        final String commentText = result['content'];
        replies.add(UserComment(
          photo: null,
          imageSource: 2,
          hasVoted: 0,
          isPostPage: true,
          isModerator: widget.isModerator,
          comment: Comments(
            profilePicture: 'assets/MonkeyDLuffy.png',
            username: 'User123',
            isImage: false,
            netVote: 0,
            content: commentText,
            createdAt: DateTime.now().toString(),
            commentId: widget.comment.commentId,
            isUpvoted: false,
            isDownvoted: false,
            isSaved: false,
            communityName: '',
            postId: '',
            title: '',
          ),
        ));
      } else if (contentType == true) {
        final File commentImage = File(result['content']);
        replies.add(UserComment(
          photo: commentImage,
          imageSource: 1,
          hasVoted: 0,
          isPostPage: true,
          isModerator: widget.isModerator,
          comment: Comments(
            profilePicture: 'assets/MonkeyDLuffy.png',
            username: 'User123',
            isImage: true,
            netVote: 0,
            content: commentImage.path,
            createdAt: DateTime.now().toString(),
            commentId: widget.comment.commentId,
            isUpvoted: false,
            isDownvoted: false,
            isSaved: false,
            communityName: '',
            postId: '',
            title: '',
          ),
        ));
      }
    }
  }

  void upVote() {
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

  void undoUpVote() {
    if (hasVoted.value == 1) {
      votes--;
      hasVoted.value = 0;
    } else if (hasVoted.value == 0) {
      votes++;
      hasVoted.value = -1;
    } else if (hasVoted.value != -1) {
      votes--;
      hasVoted.value = -1;
    }
  }

  void downVote() {
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

  void undoDownVote() {
    if (hasVoted.value == -1) {
      votes++;
      hasVoted.value = 0;
    } else if (hasVoted.value == 1) {
      votes += 2;
      hasVoted.value = 1;
    } else if (hasVoted.value != 1) {
      votes++;
      hasVoted.value = 1;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.comment.isDeleted.addListener(() {
      if (widget.comment.isDeleted.value) {
        widget.onDeleted();
      }
    });
    widget.comment.isBlocked.addListener(() {
      if (widget.comment.isBlocked.value) {
        widget.onBlock();
      }
    });
    isMinimized = ValueNotifier<bool>(false);
    votes = widget.comment.netVote;
    hasVoted = ValueNotifier<int>(widget.hasVoted);
    content = ValueNotifier<String>(widget.comment.content);
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
            elevation: 0,
            color: Palette.transparent,
            shape: Border.all(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(height: 55),
                      if (widget.isPostPage) ...[
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
                            backgroundImage:
                                NetworkImage(widget.comment.profilePicture),
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
                          formatTimestamp(
                              DateTime.parse(widget.comment.createdAt)),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ] else ...[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.comment.title ?? '',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${widget.comment.username} . r/${widget.comment.communityName}  .  ${formatTimestamp(DateTime.parse(widget.comment.createdAt))}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
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
                                        return ValueListenableBuilder<bool>(
                                          valueListenable: isMinimized,
                                          builder:
                                              (context, isMinimized, child) {
                                            String displayText = isMinimized &&
                                                    value.contains('\n')
                                                ? value.split('\n')[0]
                                                : value;
                                            return RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: MarkdownBody(
                                                      data: displayText,
                                                      styleSheet:
                                                          MarkdownStyleSheet
                                                                  .fromTheme(
                                                                      Theme.of(
                                                                          context))
                                                              .copyWith(
                                                        p: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (isMinimized &&
                                                      value.contains('\n'))
                                                    const TextSpan(text: '...'),
                                                ],
                                              ),
                                            );
                                          },
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
                                                  return Container();
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
                    if (widget.comment.isImage == false) ...[
                      ValueListenableBuilder<String>(
                        valueListenable: content,
                        builder: (context, value, child) {
                          return MarkdownBody(
                            data: value,
                            styleSheet:
                                MarkdownStyleSheet.fromTheme(Theme.of(context))
                                    .copyWith(
                              p: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            onTapLink: (text, href, title) async {
                              if (await canLaunchUrl(Uri.parse(href!))) {
                                await launchUrl(Uri.parse(href));
                              } else {
                                CustomSnackBar(
                                    context: context,
                                    content: "could not launch $href");
                              }
                            },
                          );
                        },
                      )
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
                            return Container();
                          }
                        },
                      )
                    ],
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
                                (widget.comment.username == user.username)
                                    ? 8
                                    : 7;
                            showCommentOptions(user, numofTiles);
                          },
                        ),
                        if(widget.isModerator)...[
                        IconButton(
                          icon: Transform.scale(
                            scale: 1.1,
                            child: const Icon(Icons.shield_outlined),
                          ),
                          onPressed: () {
                            modOptions(3);
                          }
                          
                        ),
                        ]
                        else
                        IconButton(
                          icon: const Icon(Icons.reply_sharp),
                          onPressed: _addReply,
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: hasVoted,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                Semantics(
                                  identifier: 'comment upvote',
                                  label: 'comment upvote',
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_upward,
                                        color: value == 1
                                            ? Palette.upvoteOrange
                                            : Palette.greyColor),
                                    onPressed: () async {
                                      int oldVotes = votes;
                                      ValueNotifier<int> oldHasVoted =
                                          ValueNotifier<int>(hasVoted.value);
                                      if (mounted) {
                                        setState(() {
                                          upVote();
                                        });
                                      }
                                      bool votedUp = await context
                                          .read<NetworkService>()
                                          .upVote(widget.comment.commentId);

                                      if (!votedUp && mounted) {
                                        setState(() {
                                          votes = oldVotes;
                                          hasVoted.value = oldHasVoted.value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Semantics(
                                  identifier: 'comment votes',
                                  label: 'comment votes',
                                  child: Text(
                                    votes == 0 && hasVoted.value == 0
                                        ? 'Vote'
                                        : '$votes',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: value == 1
                                            ? Palette.upvoteOrange
                                            : value == -1
                                                ? Palette.downvoteBlue
                                                : Palette.greyColor),
                                  ),
                                ),
                                Semantics(
                                  identifier: 'comment downvote',
                                  label: 'comment downvote',
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_downward,
                                        color: value == -1
                                            ? Palette.downvoteBlue
                                            : Palette.greyColor),
                                    onPressed: () async {
                                      int oldVotes = votes;
                                      ValueNotifier<int> oldHasVoted =
                                          ValueNotifier<int>(hasVoted.value);
                                      if (mounted) {
                                        setState(() {
                                          downVote();
                                        });
                                      }
                                      bool votedDown = await context
                                          .read<NetworkService>()
                                          .downVote(widget.comment.commentId);
                                      if (!votedDown && mounted) {
                                        setState(() {
                                          votes = oldVotes;
                                          hasVoted.value = oldHasVoted.value;
                                          undoDownVote();
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
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

  OverlayEntry? overlayEntry;

void showOverlay(int numofTiles) {
  double height = numofTiles * 56;
  overlayEntry = OverlayEntry(
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
                    content: contentValue,
                    contentType: widget.comment.isImage,
                    photo: photoValue,
                    imageSource: widget.imageSource,
                    staticComment: widget.comment,
                  );
                },
              );
            },
          )),
    ),
  );

  Overlay.of(context).insert(overlayEntry!);
}

void modOptions(int numofTiles) {
  showOverlay(numofTiles);

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromARGB(255, 19, 19, 19),
    builder: (context) {
      return Wrap(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 16, top: 14),
            alignment: Alignment.topLeft,
            child: const Text(
              'Moderator',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Palette.greyColor
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Accept Comment'),
            onTap: () {
            },
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('Remove Comment'),
            onTap: () {
            },
          ),
        ],
      );
    },
  ).then((_) {
      // Remove the overlay entry after the modal bottom sheet is dismissed
      overlayEntry?.remove();
    });
}
  
  void showCommentOptions(UserModel user, int numofTiles) {
    showOverlay(numofTiles);

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
                          commentContent: widget.comment.content,
                          contentType: widget.comment.isImage,
                          photo: widget.comment.isImage ? widget.photo : null,
                          imageSource: widget.imageSource,
                        ),
                      ),
                    );
                    if (result != null) {
                      final bool contentType = result['contentType'];
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
                title: Text(widget.comment.isSaved ? 'Unsave' : 'Save'),
                onTap: () async {
                  bool saved = await context
                      .read<NetworkService>()
                      .saveOrUnsaveComment(
                          widget.comment.commentId, !widget.comment.isSaved);
                  if (saved) {
                    CustomSnackBar(
                      context: context,
                      content: widget.comment.isSaved
                          ? 'Comment Unsaved!'
                          : 'Comment Saved!',
                    ).show();
                    widget.comment.isSaved = !widget.comment.isSaved;
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
                  if (widget.imageSource != 1) {
                    Clipboard.setData(
                        ClipboardData(text: widget.comment.content));
                    CustomSnackBar(
                      context: context,
                      content: "Copied to Clipboard",
                    ).show();
                  }
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
                      widget.comment.isDeleted.value = true;
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
                    UserModel user = await context
                        .read<NetworkService>()
                        .getUserDetails(widget.comment.username);
                    if (user.isBlocked) {
                      CustomSnackBar(
                          context: context,
                          content: 'User blocked succesfully!');
                    } else {
                      bool blocked = await context
                          .read<NetworkService>()
                          .blockUser(widget.comment.username);
                      if (blocked) {
                        widget.comment.isBlocked.value = true;
                        CustomSnackBar(
                                context: context, content: 'User blocked!')
                            .show();
                      } else {
                        CustomSnackBar(
                                context: context,
                                content: 'Failed to block User')
                            .show();
                      }
                    }
                    Navigator.pop(context);
                  },
                ),
              ReportButton(
                  isPost: false,
                  commentId: widget.comment.commentId,
                  subredditName: widget.comment.communityName),
            ],
          ),
        );
      },
    ).then((_) {
      // Remove the overlay entry after the modal bottom sheet is dismissed
      overlayEntry?.remove();
    });
  }
}
