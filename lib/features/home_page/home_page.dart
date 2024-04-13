import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cReddit/features/home_page/menu_notifier.dart';
import 'package:cReddit/features/home_page/post.dart';
import 'package:cReddit/services/networkServices.dart';

import '../../models/post_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<PostModel> posts = [];
  bool isLoading = false;
  int page = 1;
  String lastType = '';
  late String selectedMenuItem;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedMenuItem = Provider.of<MenuState>(context).selectedMenuItem;
    if (selectedMenuItem != lastType) {
      lastType = selectedMenuItem;
      page = 1;
      posts.clear();
      getPosts(selectedMenuItem);
    }
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
        page++;
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
      getPosts(selectedMenuItem);
    }
  }

  Future<void> _refreshData() async {
    await getPosts(selectedMenuItem);
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
                  height: 20,
                  thickness: 1,
                ), // Add a thin horizontal line
              ],
            );
          },
        ),
      ),
    );
  }
}
