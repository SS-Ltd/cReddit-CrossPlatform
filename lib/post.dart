import 'package:flutter/material.dart';
import 'dart:async';

class Post extends StatefulWidget {
  final String communityName;
  final String userName;
  final String title;
  final String imageUrl;
  final String content;
  final DateTime timeStamp;

  const Post({
    required this.communityName,
    required this.userName,
    required this.title,
    required this.imageUrl,
    required this.content,
    required this.timeStamp,
    super.key,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int votes = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                            backgroundImage: NetworkImage(
                                'https://www.w3schools.com/w3images/avatar2.png'),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'r/${widget.communityName}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'u/${widget.userName} . ${formatTimestamp(widget.timeStamp)}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 10),
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Visibility(
              visible: widget.imageUrl.isNotEmpty,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Text(widget.content),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () {
                    setState(() {
                      votes++;
                    });
                  },
                ),
                Text(votes.toString()),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () {
                    setState(() {
                      votes--;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                      Icons.add_comment), //other icon: add_comment, comment
                  onPressed: () {
                    // navigate to add comment page
                  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                      Icons.ios_share), //other icon: ios_share, share
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
