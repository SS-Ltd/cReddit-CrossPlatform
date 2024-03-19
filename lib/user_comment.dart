import 'package:flutter/material.dart';
import 'static_comment_card.dart';
import 'dart:async';

class UserComment extends StatefulWidget {
  final String avatar;
  final String username;
  final String content;
  final int level;
  final DateTime timestamp;

  const UserComment({
    super.key,
    // may be the required keyword need to be removed
    required this.avatar,
    required this.username,
    required this.content,
    this.level = 0,
    required this.timestamp,
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

    canvas.drawLine(const Offset(10, 0), Offset(10, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class UserCommentState extends State<UserComment> {
  int votes = 0;
  int hasVoted = 0;
  Timer? _timer;
  List<UserComment> replies = [];
  late ValueNotifier<bool> isMinimized;

  void showOverlay(BuildContext context, UserComment card) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).size.height * 0.46,
        child: Material(
          color: Colors.transparent,
          child: StaticCommentCard(
            avatar: card.avatar,
            username: card.username,
            timestamp: card.timestamp,
            content: card.content,
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
                print('Share');
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Save'),
              onTap: () {
                Navigator.pop(context);
                print('Save');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Get reply notification'),
              onTap: () {
                Navigator.pop(context);
                print('notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Copy text'),
              onTap: () {
                Navigator.pop(context);
                print('Copy text');
              },
            ),
            ListTile(
              leading: const Icon(Icons.merge_type_outlined),
              title: const Text('Collapse thread'),
              onTap: () {
                Navigator.pop(context);
                print('Collapse thread');
              },
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Block account'),
              onTap: () {
                Navigator.pop(context);
                print('Block account');
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                print('Report');
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

  void _addReply() {
    setState(() {
      replies.add(
        UserComment(
          avatar: 'assets/MonkeyDLuffy.png',
          username: 'reply_username',
          content: 'reply_content',
          level: widget.level + 1,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    isMinimized = ValueNotifier<bool>(false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SingleChildScrollView(
        child: Column(
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
                  padding: const EdgeInsets.fromLTRB(12, 7, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(widget.avatar),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.username,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatTimestamp(widget.timestamp),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          if (isMinimized.value) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.content,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!isMinimized.value) ...[
                        const SizedBox(height: 10),
                        Text(
                          widget.content,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                showOverlay(context, widget);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.reply_sharp),
                              onPressed: _addReply,
                            ),
                            IconButton(
                              icon: const Icon(Icons.arrow_upward),
                              onPressed: () {
                                if (hasVoted != 1) {
                                  setState(() {
                                    votes++;
                                    hasVoted = 1;
                                  });
                                }
                              },
                            ),
                            Text('$votes'),
                            IconButton(
                              icon: const Icon(Icons.arrow_downward),
                              onPressed: () {
                                if (hasVoted != -1) {
                                  setState(() {
                                    votes--;
                                    hasVoted = -1;
                                  });
                                }
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
        ),
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
