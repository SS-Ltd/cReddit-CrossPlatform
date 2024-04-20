import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/utils/utils_time.dart';

/// A card widget that displays a static comment.
class StaticCommentCard extends StatelessWidget {
  final String content;
  final File? photo;
  final bool contentType;
  final int imageSource; //0 from backend 1 from user 2 text
  final Comments staticComment;

  /// Constructs a [StaticCommentCard] widget.
  ///
  /// The [content] parameter is the comment content.
  /// The [photo] parameter is an optional photo associated with the comment.
  /// The [contentType] parameter indicates the type of content (text or image).
  /// The [imageSource] parameter indicates the source of the image (backend, user, or text).
  /// The [staticComment] parameter is the comment object.
  const StaticCommentCard({
    super.key,
    this.content = '',
    this.photo,
    required this.contentType,
    required this.imageSource,
    required this.staticComment,
  });

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
                  backgroundImage: NetworkImage(staticComment.profilePicture),
                ),
                const SizedBox(width: 10),
                Text(
                  staticComment.username,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Text(
                  formatTimestamp(DateTime.parse(staticComment.createdAt)),
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
