import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({Key? key}) : super(key: key);

  @override
  _SavedPostsState createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  List<PostModel> posts = [];
  bool isLoading = false;
  int page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchSavedPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchSavedPosts() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      List<PostModel>? newPosts =
          await context.read<NetworkService>().getSavedPosts(page: page);
      if (mounted) {
        if (newPosts != null) {
          setState(() {
            posts.addAll(newPosts);
            page++;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0 &&
        !isLoading) {
      _fetchSavedPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          posts.clear();
          page = 1;
        });
        await _fetchSavedPosts();
      },
      child: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < posts.length) {
            return postWidget(posts[index]); // Your post widget here
          } else {
            return Center(child: CircularProgressIndicator());
          }
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
          postType: postModel.type,
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
