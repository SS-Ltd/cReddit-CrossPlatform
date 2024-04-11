import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';

class StaticCommentCard extends StatelessWidget {
  final String avatar;
  final String username;
  final String content;
  final DateTime timestamp;
  final File? photo;
  final bool contentType;
  final int imageSource; //0 from backend 1 from user 2 text

  const StaticCommentCard({
    Key? key,
    required this.avatar,
    required this.username,
    this.content = '',
    required this.timestamp,
    this.photo,
    required this.contentType,
    required this.imageSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 12, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 7, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(avatar),
                ),
                const SizedBox(width: 10),
                Text(
                  username,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  formatTimestamp(timestamp),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            contentType == false
                ? Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  )
                : contentType == true && imageSource == 0
                    ? SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          content,
                          fit: BoxFit.contain,
                        ),
                      )
                    : contentType == true && imageSource == 1
                        ? SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.file(
                              photo!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const SizedBox(height: 20),
            const SizedBox(height: 10)
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
