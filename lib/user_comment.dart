import 'package:flutter/material.dart';
import 'dart:async';

class UserComment extends StatefulWidget {
  final String username;
  final String content;
  final int level;
  final DateTime timestamp;

  const UserComment({
    Key? key,
    required this.username,
    required this.content,
    this.level = 0,
    required this.timestamp,
  }) : super(key: key);

  @override
  _UserCommentState createState() => _UserCommentState();
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _UserCommentState extends State<UserComment> {
  int votes = 0;
  Timer? _timer;
  List<UserComment> replies = [];

  void _addReply() {
    setState(() {
      replies.add(
        UserComment(
          username: 'reply_username',
          content: 'reply_content',
          level: widget.level + 1,
          timestamp: DateTime.now(),
        ),
      );
    });
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

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
      padding: const EdgeInsets.only(left: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Colors.black,
              //margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          // Replace with your user's avatar image
                          backgroundImage: NetworkImage(
                              'https://example.com/user_avatar.png'),
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
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        widget.content), // Use the content passed to the widget
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Spacer(),
                        PopupMenuButton(
                          icon: const Icon(Icons.more_vert),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text('Report'),
                              onTap: () => print('Report clicked'),
                            ),
                            PopupMenuItem(
                              child: const Text('Save'),
                              onTap: () => print('Save clicked'),
                            ),
                            PopupMenuItem(
                              child: const Text('Permalink'),
                              onTap: () => print('Permalink clicked'),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.reply_sharp),
                          onPressed: _addReply,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              votes++;
                            });
                          },
                        ),
                        Text('$votes'),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward),
                          onPressed: () {
                            setState(() {
                              votes--;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            for (var reply in replies)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: CustomPaint(
                  painter: LinePainter(),
                  child: reply,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
