import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';

/// This widget displays a list of saved posts.
///
/// The [SavedPosts] widget is a stateful widget that fetches and displays a list of saved posts.
/// It uses a [ScrollController] to detect when the user has scrolled to the end of the list and
/// fetches more posts accordingly. The list of posts is displayed using a [ListView.builder],
/// and a [RefreshIndicator] is added to allow the user to refresh the list by pulling down.
///
/// The [SavedPosts] widget requires a [BuildContext] to access the [NetworkService] and
/// fetch the saved posts. It also requires a [Key] for widget identification.
///
/// Example usage:
///
/// ```dart
/// SavedPosts(key: UniqueKey())
/// ```
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

  /// Fetches the saved posts from the network.
  ///
  /// This method is called when the widget is initialized and when the user scrolls to the end
  /// of the list. It sets the [isLoading] flag to true, fetches the saved posts using the
  /// [NetworkService], and updates the state accordingly. If new posts are fetched, they are
  /// added to the [posts] list and the [page] counter is incremented. If no new posts are
  /// fetched, the [isLoading] flag is set to false.
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

  /// Callback function for scroll events.
  ///
  /// This method is called when the user scrolls the list. It checks if the user has scrolled
  /// to the end of the list and if the [isLoading] flag is false. If both conditions are met,
  /// it calls the [_fetchSavedPosts] method to fetch more posts.
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

  /// Builds the widget for a single post.
  ///
  /// This method is called by the [ListView.builder] to build the widget for each post in the
  /// [posts] list. It takes a [PostModel] as a parameter and returns a [Column] widget that
  /// displays the post information. The [Post] widget is used to display the post details,
  /// and a [Divider] widget is added below each post.
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
