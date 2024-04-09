import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/rightsidebar.dart';
import 'package:reddit_clone/features/home_page/select_item.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

import '../../models/post_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    getPosts(selectedMenuItem);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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
    List<PostModel>? fetchedPosts = await context
        .read<NetworkService>()
        .fetchUserPosts(page: page, sort: selectedItem.toLowerCase());
    if (fetchedPosts != null) {
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
    if (_scrollController.position.pixels ==
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
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, size: 30.0),
            ),
            SelectItem(
              menuItems: menuItems,
              onMenuItemSelected: (String selectedItem) {
                // Handle menu item selection here
                setState(() {
                  selectedMenuItem = selectedItem;
                });
                getPosts(
                    selectedItem); // Fetch posts for the selected menu item
                print('Selected: $selectedItem');
              },
            ),
          ],
        ),
        leadingWidth: 150,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, size: 30.0),
          ),
          IconButton(
            onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
            icon: const Icon(Icons.reddit, size: 30.0),
          ),
        ],
      ),
      endDrawer: const Rightsidebar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController, // Attach ScrollController here
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostWidget(post: posts[index]);
          },
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Post(
        //   communityName: post.communityName,
        //   userName: post.username,
        //   title: post.title,
        //   imageUrl: post.imageUrl,
        //   content: post.content,
        //   commentNumber: post.commentCount,
        //   shareNumber: post.netVote,
        //   timeStamp: post.createdAt,
        //   isHomePage: true,
        // ),
        //for now fake with post title
        Text(post.title),
        const Divider(height: 200, thickness: 1), // Add a thin horizontal line
      ],
    );
  }
}
