import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/services/networkServices.dart';

import '../../models/post_model.dart';

class HomePage extends StatefulWidget {
  final String selectedMenuItem;
  const HomePage({super.key, required this.selectedMenuItem});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> menuItems = ['Hot', 'Top', 'New'];
  // Store the selected menu item here
  String lastType = "Hot";
  List<PostModel> posts = [];
  bool isLoading = false;
  int page = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    posts.clear();
    page = 1;
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        getPosts(widget.selectedMenuItem);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getPosts(String selectedItem) async {
    setState(() {
      isLoading = true;
    });
    List<PostModel>? fetchedPosts = await context
        .read<NetworkService>()
        .fetchHomeFeed(page: page, sort: selectedItem.toLowerCase());
    if (fetchedPosts != null && mounted) {
      setState(() {
        posts.addAll(fetchedPosts);
        isLoading = false;
        page++; // Increment page for the next fetch
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      getPosts(
          widget.selectedMenuItem); // Fetch more posts when user reaches end
    }
  }

  Future<void> _refreshData() async {
    await getPosts(widget.selectedMenuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Column(
              children: [
                Post(
                  communityName: post.communityName ?? '',
                  userName: post.username,
                  title: post.title,
                  postType: post.type,
                  content: post.content,
                  commentNumber: post.commentCount,
                  shareNumber: 0,
                  timeStamp: post.uploadDate ?? DateTime.now(),
                  pollOptions: post.pollOptions,
                  isSubRedditPage: false,
                  profilePicture: post.profilePicture,
                  isHomePage: true,
                  postId: post.postId,
                  votes: post.netVote,
                  isDownvoted: post.isDownvoted,
                  isUpvoted: post.isUpvoted,
                ),
                const Divider(
                    height: 20, thickness: 1), // Add a thin horizontal line
              ],
            );
          },
        ),
      ),
    );
  }
}
