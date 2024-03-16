import 'package:flutter/material.dart';
import 'dart:async';


class Post extends StatefulWidget {
  final String communityName;
  final String userName;
  final String title;
  final String content;
  final DateTime timeStamp;

  const Post({
    required this.communityName,
    required this.userName,
    required this.title,
    required this.content,
    required this.timeStamp,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
    int votes = 0;
    Timer? _timer;

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
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding : const EdgeInsets.all(16.0),
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
                        const CircleAvatar(
                          //replace with user profile picture
                          backgroundImage: NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'r/${widget.communityName}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'u/${widget.userName} . ${formatTimestamp(widget.timeStamp)}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.content),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    setState(() {
                      votes++;
                    });
                  },
                ),
                Text(votes.toString()),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      votes--;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.comment),
                  onPressed: () {
                    // navigate to add comment page 
                  },
                ),
                Spacer(),
                // add icon for share to the most right
                IconButton(
                  // make the icon share to the most right
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // share post
                  }, 
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
