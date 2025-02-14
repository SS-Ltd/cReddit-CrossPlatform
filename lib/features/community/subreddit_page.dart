// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/community/rules_page.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/moderator/mod_tools.dart';
import 'package:reddit_clone/features/search/general_search.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/palette.dart';

/// This file contains the implementation of the [SubRedditPage] widget.
/// The [SubRedditPage] widget displays a subreddit page with posts, subreddit information, and sorting options.
/// It fetches subreddit details and posts from a network service and renders them in a custom scroll view.
/// The user can scroll through the posts, load more posts, and change the sorting options.
/// The [SubRedditPage] widget is a stateful widget that manages the loading state, pagination, and sorting state.
/// It also handles user interactions such as tapping on sorting options and post widgets.
/// The widget uses various other widgets such as [AppBar], [CustomScrollView], [SliverToBoxAdapter], [SliverList], [ListTile], [Icon], [Text], [CircleAvatar], and [Container] to build the UI.
/// The widget relies on a network service provided by the [Provider] package to fetch subreddit details and posts.
/// The subreddit details include the subreddit icon, banner, description, number of members, rules, and moderators.
/// The posts are fetched in batches using pagination and sorted based on the selected sorting option.
/// Each post is rendered using the [Post] widget, which displays the post's community name, username, title, type, profile picture, content, comment count, share count, timestamp, votes, and voting state.
/// The widget also includes sorting options, which allow the user to change the sorting order of the posts.
/// The sorting options include 'Hot', 'New', and 'Top', and are displayed in a modal bottom sheet when tapped.
/// The widget updates the UI dynamically when the sorting option is changed or when new posts are loaded.
/// The widget also includes subreddit information, such as the subreddit name, number of members, and online members.
/// The subreddit information is displayed in a container with a dark background color.
/// The subreddit icon is displayed as a circle avatar, and the subreddit banner is displayed as a background image in the app bar.
/// The widget also includes loading indicators to indicate when more posts are being loaded.
/// The widget uses a scroll controller to listen for scroll events and load more posts when the user reaches the end of the scroll view.
/// The widget manages the loading state, pagination, and sorting state using state variables and the [setState] method.
/// The widget also disposes of the scroll controller when it is no longer needed to prevent memory leaks.
class SubRedditPage extends StatefulWidget {
  final String subredditName;

  const SubRedditPage({super.key, required this.subredditName});

  @override
  State<SubRedditPage> createState() => _SubRedditPageState();
}

/// The state class for the [SubRedditPage] widget.
/// It manages the loading state, pagination, and sorting state of the subreddit page.
/// It also handles user interactions and fetches subreddit details and posts from a network service.
class _SubRedditPageState extends State<SubRedditPage> {
  late final ValueNotifier<bool> isJoined;
  Future<bool>? _future;
  bool isMember = false;
  bool isModerator = false;
  String currentSort = 'Hot';
  String currentIcon = 'Hot';
  List<String> posts = List.generate(20, (index) => 'Post $index');
  List<PostModel> subredditPosts = [];
  int page = 1;
  bool hasMore = true; // to track if more items are available to
  // prevent unnecessary requests
  bool isLoading = false; // to track loading state
  final ScrollController _scrollController = ScrollController();

  String _subredditIcon = '';
  String _subredditBanner = 'https://picsum.photos/200/300';
  String _subredditDescription = '';
  int _subredditMembers = 0;
  List<String> _subredditRules = [];
  List<String> _subredditModerators = [];
  @override
  void initState() {
    super.initState();
    isJoined = ValueNotifier<bool>(false);
    _scrollController.addListener(_onScroll);
    fetchSubredditDetails();
    fetchPosts();
  }

  @override
  void dispose() {
    //_scrollController.dispose();
    super.dispose();
  }

  Future<bool> joinOrDisjoinSubreddit() async {
    bool result;
    if (!isJoined.value) {
      result = await context
          .read<NetworkService>()
          .joinSubReddit(widget.subredditName!);
    } else {
      result = await context
          .read<NetworkService>()
          .disJoinSubReddit(widget.subredditName!);
    }
    if (mounted && result) {
      isJoined.value = !isJoined.value;
    }
    return result;
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMore &&
        !isLoading) {
      fetchPosts(); // Load more posts
    }
  }

  Future<void> fetchPosts() async {
    if (isLoading || !hasMore) {
      return; // Exit if already loading or no more posts to load
    }

    if (mounted) {
      setState(() {
        isLoading = true; // Set loading state to true
      });
    }

    final networkService = Provider.of<NetworkService>(context, listen: false);
    final posts = await networkService.fetchPostsForSubreddit(
        widget.subredditName!,
        page: page,
        sort: currentSort.toLowerCase());

    if (posts != null && posts.isNotEmpty) {
      for (var element in posts) {
        element.isJoined = isMember;
        element.isModerator = isModerator;
      }
    }

    if (posts != null && posts.isNotEmpty) {
      if (mounted) {
        setState(() {
          subredditPosts.addAll(posts);
          page++; // Increment page to load the next batch next time
        });
      }
    } else {
      if (mounted) {
        setState(() {
          hasMore = false; // No more posts to load
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  Future<void> fetchSubredditDetails() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    for (var subreddit in networkService.user?.recentlyVisited ?? {}) {}
    final details =
        await networkService.getSubredditDetails(widget.subredditName);
    if (details != null) {
      if (details.isNSFW) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('NSFW Content'),
            content: const Text(
                'This subreddit contains NSFW content and cannot be viewed.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Go back to the previous page
                },
              ),
            ],
          ),
        );
      } else {
        networkService.user?.recentlyVisited.add(details);
        if (mounted) {
          setState(() {
            isMember = details.isMember;
            isModerator = details.isModerator;
            isJoined.value = isMember;
            _subredditIcon = details.icon;
            _subredditBanner =
                details.banner ?? 'https://picsum.photos/200/300';
            _subredditMembers = details.members;
            _subredditRules = details.rules;
            _subredditModerators = details.moderators;
            _subredditDescription = details.description!;
            _subredditModerators = details.moderators;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('r/${widget.subredditName}',
            style: const TextStyle(color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_subredditBanner),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Semantics(
              label: "search subreddit",
              identifier: "search subreddit",
              child: _iconButtonWithBackground(Icons.search, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => GeneralSearch(
                      communityName: widget.subredditName,
                      displayName: "",
                      username: "",
                    ),
                  ),
                );
              })),
          Semantics(
              label: "share subreddit",
              identifier: "share subreddit",
              child: _iconButtonWithBackground(Icons.share_outlined, () {})),
          Semantics(
              label: "subreddit options",
              identifier: "subreddit options",
              child: _iconButtonWithBackground(Icons.more_vert, () {})),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(child: _subredditInfo()),
          SliverToBoxAdapter(
              child: Semantics(
                  label: "subreddit sorting options",
                  identifier: "subreddit sorting options",
                  child: _sortingOptions())),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index < subredditPosts.length) {
                  return postWidget(subredditPosts[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
              childCount: hasMore
                  ? subredditPosts.length + 1
                  : subredditPosts.length, // Add extra space ->
              //loading indicator if more items are coming
            ),
          ),
        ],
      ),
    );
  }

  Widget postWidget(PostModel postModel) {
    return Column(
      children: [
        Post(
          shareNumber: 0, // Adjust accordingly if your model includes this info
          postModel: postModel,
          isHomePage: true,
          isSubRedditPage: true,
          onRemove: () {
            setState(() {
              subredditPosts.remove(postModel);
            });
          },
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _sortingOptions() {
    return ListTile(
      title: Row(
        children: [
          if (currentSort == 'Hot')
            const Icon(Icons.whatshot_outlined, color: Colors.white),
          if (currentSort == 'New')
            const Icon(Icons.new_releases_outlined, color: Colors.white),
          if (currentSort == 'Top')
            const Icon(Icons.arrow_upward_outlined, color: Colors.white),
          const SizedBox(width: 8),
          Text(currentSort, style: const TextStyle(color: Colors.white)),
        ],
      ),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: const Color.fromARGB(255, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _sortingOptionTile('Hot', Icons.whatshot_outlined, () {
                    setState(() {
                      currentSort = 'Hot';
                    });
                    Navigator.pop(context);
                  }),
                  _sortingOptionTile('New', Icons.new_releases_outlined, () {
                    setState(() {
                      currentSort = 'New';
                    });
                    Navigator.pop(context);
                  }),
                  _sortingOptionTile('Top', Icons.arrow_upward_outlined, () {
                    setState(() {
                      currentSort = 'Top';
                    });
                    Navigator.pop(context);
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sortingOptionTile(String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        if (currentSort != title) {
          setState(() {
            currentSort = title; // Update the current sort
            subredditPosts.clear(); // Clear existing posts
            page = 1; // Reset pagination
            hasMore = true; // Reset the 'hasMore' flag to enable new fetches
          });
          Navigator.pop(context); // Close the sort selection modal
          fetchPosts(); // Fetch new sorted posts
        }
      },
    );
  }

  Widget _subredditInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color.fromRGBO(27, 27, 27, 1),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: _subredditIcon.isNotEmpty
                    ? NetworkImage(_subredditIcon)
                    : const NetworkImage('https://picsum.photos/200/300'),
                radius: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('r/${widget.subredditName}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    Row(
                      children: [
                        Text('$_subredditMembers members  ',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('$_subredditMembers online',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              isModerator
                  ? ElevatedButton(
                      onPressed: () {
                        // Navigate to the mod tools page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModeratorTools(
                                communityName: widget.subredditName),
                          ),
                        );
                      },
                      child: const Text('Mod Tools'),
                    )
                  : ValueListenableBuilder<bool>(
                      valueListenable: isJoined,
                      builder: (context, value, child) {
                        return SizedBox(
                          height: 33,
                          child: ButtonTheme(
                            minWidth: 0,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _future = joinOrDisjoinSubreddit();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: value
                                    ? Palette.transparent
                                    : Palette.blueJoinColor,
                                foregroundColor: value
                                    ? Palette.blueJoinedColor
                                    : Palette.whiteColor,
                                side: value
                                    ? const BorderSide(
                                        color: Palette.blueJoinedColor,
                                        width: 2.0)
                                    : BorderSide.none,
                                padding: EdgeInsets.zero, // Add this line
                              ),
                              child: FutureBuilder<bool>(
                                future: _future,
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Palette.blueJoinedColor),
                                      ),
                                    );
                                  } else {
                                    return Text(
                                        isJoined.value ? 'Joined' : 'Join');
                                  }
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _subredditDescription,
            style: const TextStyle(color: Colors.white),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: TextButton(
              child:
                  const Text('See more', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RulesPage(
                      rules: _subredditRules,
                      description: _subredditDescription,
                      subredditName: widget.subredditName ?? '',
                      moderators: _subredditModerators,
                      bannerURL: _subredditBanner,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButtonWithBackground(IconData icon, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.black45, // Semi-transparent black
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
