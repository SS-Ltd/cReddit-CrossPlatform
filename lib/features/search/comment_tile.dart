import 'package:flutter/material.dart';
import 'package:reddit_clone/models/search.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});
  final SearchComments comment;

  @override
  Widget build(BuildContext context) {
    bool isCommunity = comment.communityName != '';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(comment.commentPicture),
              ),
              const SizedBox(
                width: 10,
              ),
              isCommunity
                  ? Text(
                      'r/${comment.communityName}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    )
                  : Text('u/${comment.username}'),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          Text(comment.postTitle),
          
        ],
      ),
    );
  }
}
