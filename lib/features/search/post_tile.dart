import 'package:flutter/material.dart';
import 'package:reddit_clone/models/search.dart';

class PostTile extends StatelessWidget {
  const PostTile({super.key, required this.post, required this.isProfile});
  final SearchPosts post;
  final bool isProfile;
  
  @override
  Widget build(BuildContext context) {
    bool isCommunity = post.communityName != '';
    bool imageType = post.type == 'Images & Video';
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
      child: Column(
        //think to change this into card
        children: [
          Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.profilePicture),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  isProfile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'r/${post.communityName}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text('u/${post.username}'),
                          ],
                        )
                      : isCommunity
                          ? Text(
                              'r/${post.communityName}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          : Text('u/${post.username}'),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      post.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '${post.netVote} upvotes  ',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(1),
                    ),
                  ),
                  Text(
                    '${post.commentCount} comments',
                    style: TextStyle(
                      color: Colors.grey.withOpacity(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //will place the image
          if (imageType)
            const Column(
              children: [],
            ),
        ],
      ),
    );
  }
}
