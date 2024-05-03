import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
import 'package:reddit_clone/features/home_page/menu_notifier.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/services/networkServices.dart';

import '../../models/post_model.dart';

/// The home page of the cReddit CrossPlatform app.
///
/// This page displays a list of posts fetched from the API based on the selected menu item.
/// It uses a [ListView.builder] to render the posts in a scrollable list.
/// The page supports pull-to-refresh functionality using a [RefreshIndicator].
///
/// The [HomePage] class is a [StatefulWidget] that manages the state of the page.
/// It has a [ScrollController] to listen for scroll events and trigger the loading of more posts.
/// The state of the page is managed by the [_HomePageState] class, which extends [State<HomePage>].
///
/// The [_HomePageState] class has the following state variables:
/// - [posts]: A list of [PostModel] objects representing the fetched posts.
/// - [isLoading]: A boolean flag indicating whether the page is currently loading more posts.
/// - [page]: An integer representing the current page number of the fetched posts.
/// - [lastType]: A string representing the last selected menu item.
/// - [selectedMenuItem]: A string representing the currently selected menu item.
///
/// The [_HomePageState] class overrides the [initState], [dispose], and [didChangeDependencies] methods
/// to initialize and clean up resources, as well as to handle changes in the selected menu item.
///
/// The [getPosts] method is an asynchronous function that fetches posts from the API based on the selected menu item.
/// It updates the state variables accordingly and triggers a UI update using [setState].
///
/// The [_onScroll] method is called when the user scrolls to the bottom of the list.
/// It checks if more posts can be loaded and calls [getPosts] if necessary.
///
/// The [_refreshData] method is an asynchronous function that refreshes the data by calling [getPosts].
///
/// The [build] method builds the UI of the page using a [Scaffold] widget.
/// It wraps the list of posts in a [RefreshIndicator] to enable pull-to-refresh functionality.
/// Each post is rendered using a [Column] widget, with a [Post] widget and a [Divider] widget.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      getPosts(selectedMenuItem.toLowerCase());
    }
  }

  void cleanItems() {
    posts.clear();
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      getPosts(selectedMenuItem);
    }
  }

  Future<void> _refreshData() async {
    cleanItems();
    await getPosts(selectedMenuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: posts.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < posts.length) {
              final post = posts[index];
              return Column(
                children: [
                  Post(
                    postModel: post,
                    shareNumber: 0,
                    isSubRedditPage: false,
                    isHomePage: true,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                ],
              );
            } else {
              return CustomLoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
