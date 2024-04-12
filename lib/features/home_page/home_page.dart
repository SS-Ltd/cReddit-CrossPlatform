import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/services/networkServices.dart';

import '../../models/post_model.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
 // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> menuItems = ['Hot', 'Top', 'New'];
  String selectedMenuItem = 'Hot'; // Store the selected menu item here
  String lastType = "Hot";
  List<PostModel> posts = [];
  bool isLoading = false;
  int page = 1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        getPosts(selectedMenuItem);
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
    if (selectedMenuItem != lastType) {
      posts.clear();
      page = 1;
      lastType = selectedItem;
    }
    setState(() {
      isLoading = true;
    });
    // List<PostModel>? fetchedPosts = await context
    //     .read<NetworkService>()
    //     .fetchHomeFeed(page: page, sort: selectedItem.toLowerCase());
    // if (fetchedPosts != null && mounted) {
    //   setState(() {
    //     posts.addAll(fetchedPosts);
    //     isLoading = false;
    //     page++; // Increment page for the next fetch
    //   });
    // } else {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      getPosts(selectedMenuItem); // Fetch more posts when user reaches end
    }
  }

  Future<void> _refreshData() async {
    await getPosts(selectedMenuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      // appBar: AppBar(
      //   leading: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     children: [
      //       IconButton(
      //         onPressed: () {},
      //         icon: const Icon(Icons.menu, size: 30.0),
      //       ),
      //       SelectItem(
      //         menuItems: menuItems,
      //         onMenuItemSelected: (String selectedItem) {
      //           setState(() {
      //             selectedMenuItem = selectedItem;
      //           });
      //           getPosts(
      //               selectedItem); // Fetch posts for the selected menu item
      //           print('Selected: $selectedItem');
      //         },
      //       ),
      //     ],
      //   ),
      //   leadingWidth: 150,
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.search, size: 30.0),
      //     ),
      //     IconButton(
      //       onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
      //       icon: const Icon(Icons.reddit, size: 30.0),
      //     ),
      //   ],
      // ),
      // endDrawer: const Rightsidebar(),
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
