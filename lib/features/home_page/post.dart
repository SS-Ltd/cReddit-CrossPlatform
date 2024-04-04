import 'package:flutter/material.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'dart:async';
import '../../new_page.dart';
import 'post_comment.dart';
import 'package:reddit_clone/features/User/profile.dart';


class Post extends StatefulWidget {
  final String communityName;
  final String userName;
  final String title;
  final String imageUrl;
  final String content;
  final int commentNumber;
  final int shareNumber;
  final DateTime timeStamp;
  final bool isHomePage;

  const Post({
    required this.communityName,
    required this.userName,
    required this.title,
    required this.imageUrl,
    required this.content,
    this.commentNumber = 0,
    this.shareNumber = 0,
    required this.timeStamp,
    this.isHomePage = true,
    Key? key,
  }) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  int votes = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
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
                      widget.isHomePage
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NewPage()), //replace with community page
                                );
                              },
                              child: Text(
                                'r/${widget.communityName}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'r/${widget.communityName}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Profile (
                                                userName: widget.userName,
                                                displayName: widget.userName,
                                                about: 'Hello to my profile!',
                                                profilePicture: 'https://www.w3schools.com/w3images/avatar2.png',
                                                bannerPicture: 'drive.creddit.com/pfp',
                                                followerCount: 0,
                                                cakeDay: '2024-03-25T15:37:33.339+00:00',
                                                isOwnProfile: false,
                                              ), //replace with profile page or widget
                                      )
                                    );
                                  },
                                  child: Text(
                                    'u/${widget.userName} . ${formatTimestamp(widget.timeStamp)}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 10),
          GestureDetector(
            onTap: widget.isHomePage
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:(context) => PostComment(),
                        // builder: (context) => Post(
                        //   communityName: widget.communityName,
                        //   userName: widget.userName,
                        //   title: widget.title,
                        //   imageUrl: widget.imageUrl,
                        //   content: widget.content,
                        //   commentNumber: widget.commentNumber,
                        //   shareNumber: widget.shareNumber,
                        //   timeStamp: widget.timeStamp,
                        //   isHomePage: false,
                        // ),
                      ), //replace with post and comment page
                    );
                  }
                : null,
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          // const SizedBox(height: 10),
          Visibility(
            visible: widget.imageUrl.isNotEmpty,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // builder: (context) => ImageScreen(imageUrl: widget.imageUrl),
                    builder: (context) => const NewPage(),
                    //replace with image screen
                  ),
                );
              },
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
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.isHomePage
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:(context) => PostComment(), 
                        // builder: (context) => Post(
                        //   communityName: widget.communityName,
                        //   userName: widget.userName,
                        //   title: widget.title,
                        //   imageUrl: widget.imageUrl,
                        //   content: widget.content,
                        //   commentNumber: widget.commentNumber,
                        //   shareNumber: widget.shareNumber,
                        //   timeStamp: widget.timeStamp,
                        //   isHomePage: false,
                        // ),
                      ), //replace with post and comment page
                    );
                  }
                : null,
            child: widget.isHomePage && widget.imageUrl.isEmpty
                ? (Text(
                    widget.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ))
                : (!widget.isHomePage
                    ? Text(widget.content)
                    : const SizedBox.shrink()),
          ),
          // const SizedBox(height: 10),
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
                icon: const Icon(Icons.add_comment),
                //other icon: add_comment,comment
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommentPage(),
                    ),
                  );
                },
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
