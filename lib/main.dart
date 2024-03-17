import 'package:flutter/material.dart';
import 'home.dart';
import 'user_comment.dart';
import 'theme/app_theme.dart';
void main() {
  runApp(MaterialApp(
    theme: AppTheme.theme,
    initialRoute: '/comment',
    routes: {
      '/comment': (context) => UserComment(username: 'User123', content: 'This is a comment from User123', timestamp: DateTime.now()),
      '/home': (context) => const Home(),
      //'/commentpage':(context) => const CommentPage(),
      },
  ));
}

/*
class _UserCommentState extends State<UserComment> {
  int votes = 0;
  Timer? _timer;
  List<UserComment> replies = [];
  bool isMinimized = false; // Add this line

  // ... rest of your code ...

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector( // Wrap the Card with GestureDetector
              onTap: () {
                setState(() {
                  isMinimized = !isMinimized; // Toggle isMinimized when the card is tapped
                });
              },
              child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: NetworkImage('https://example.com/user_avatar.png'),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.username,
                            style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatTimestamp(widget.timestamp),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      if (!isMinimized) ...[ // Only render the rest of the card if isMinimized is false
                        const SizedBox(height: 10),
                        Text(widget.content),
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
                    ],
                  ),
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


*/