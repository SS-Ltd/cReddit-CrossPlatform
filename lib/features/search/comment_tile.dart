import 'package:flutter/material.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:reddit_clone/theme/palette.dart';

//small card has rgba 255, 8,8,8
//large card has rgba 255, 19,19,19

class CommentTile extends StatelessWidget {
  const CommentTile(
      {super.key, required this.comment, required this.isProfile});
  final SearchComments comment;
  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    bool isCommunity = comment.communityName != '';

    return Card(
      color: Palette.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: BorderSide(color: Colors.grey[850]!, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.commentPicture),
                  radius: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                isProfile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'r/${comment.communityName}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text('u/${comment.username}'),
                        ],
                      )
                    : isCommunity
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
            Text(
              comment.postTitle,
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: 500,
              child: Card(
                color: Palette.commentTile,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(comment.postPicture),
                            radius: 15,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('u/${comment.username}'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(comment.content),
                      const SizedBox(
                        height: 10,
                      ),
                      Text('${comment.netVote.toString()} upvotes'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {},
              child: const Text('Go to comments'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text('${comment.commentCount.toString()} comments'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
