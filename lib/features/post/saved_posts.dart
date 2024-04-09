import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({super.key});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  List<PostModel>? savedPosts;

  @override
  void initState() {
    super.initState();
    fetchSavedPosts();
  }

  Future<void> fetchSavedPosts() async {
    final posts = await Provider.of<NetworkService>(context, listen: false)
        .getSavedPosts();
    if (posts != null) {
      setState(() => savedPosts = posts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: savedPosts == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: savedPosts!.length,
              itemBuilder: (context, index) {
                return postWidget(savedPosts![index]);
              },
            ),
    );
  }

  Widget postWidget(PostModel postModel) {
    return Column(
      children: [
        Post(
          communityName: postModel.communityName ?? '',
          userName: postModel.username,
          title: postModel.title,
          profilePicture: postModel.profilePicture,
          imageUrl: '', // Assuming this is the image URL
          content: postModel.content,
          commentNumber: postModel.commentCount,
          shareNumber: 0, // Adjust accordingly if your model includes this info
          timeStamp: postModel.uploadDate ?? DateTime.now(),
          isHomePage: true, // Adjust based on your design/requirements
          isSubRedditPage: false,
          postId: postModel.postId,
          votes: postModel.netVote,
          isDownvoted: postModel.isDownvoted,
          isUpvoted: postModel.isUpvoted,
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
