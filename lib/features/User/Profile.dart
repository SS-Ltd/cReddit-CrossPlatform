import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/comments/user_comment.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/post_options_menu.dart';
import 'package:intl/intl.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'follow_unfollow_button.dart';
import 'chat_button.dart';
import 'package:reddit_clone/features/User/edit_button.dart';
import 'package:reddit_clone/features/search/profile_search.dart';

enum TabSelection { posts, comments, about }

/// A widget representing the user profile.
class Profile extends StatefulWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String userName;
  final String profileName;
  final String displayName;
  final String about;
  final String profilePicture;
  final String bannerPicture;
  final int followerCount;
  final String cakeDay;
  TabSelection selectedTab = TabSelection.posts;
  final bool isOwnProfile;

  Profile({
    required this.userName,
    required this.profileName,
    required this.displayName,
    required this.about,
    required this.profilePicture,
    required this.bannerPicture,
    required this.followerCount,
    required this.cakeDay,
    this.isOwnProfile = false,
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

/// Maps the boolean values [isUpvoted] and [isDownvoted] to an integer value.
int mappingVotes(bool isUpvoted, bool isDownvoted) {
  if (isUpvoted) {
    return 1;
  } else if (isDownvoted) {
    return -1;
  } else {
    return 0;
  }
}

class _ProfileState extends State<Profile> {
  // final List<String> feedMenuItems = ['hot', 'top', 'new'];
  bool isLoadingPosts = false;
  bool hasMorePosts = true;
  int postsPage = 1;

  bool isLoadingComments = false;
  bool hasMoreComments = true;
  int commentsPage = 1;

  List<PostModel> userPosts = [];
  List<Comments> userComments = [];

  /// Fetches the user posts from the network.
  Future<void> fetchUserPosts({bool refresh = false}) async {
    if (isLoadingPosts) return;
    if (refresh) {
      userPosts = [];
      postsPage = 1;
      hasMorePosts = true;
    }
    if (!hasMorePosts) return;

    setState(() {
      isLoadingPosts = true;
    });

    final networkService = Provider.of<NetworkService>(context, listen: false);
    final posts = await networkService.fetchUserPosts(
      widget.userName,
      page: postsPage,
      limit: 100, // or another appropriate limit
    );

    setState(() {
      if (posts != null && posts.isNotEmpty) {
        userPosts.addAll(posts);
        postsPage++;
      } else {
        hasMorePosts = false;
      }
      isLoadingPosts = false;
    });
  }

  /// Fetches the user comments from the network.
  Future<void> fetchUserComments({bool refresh = false}) async {
    if (isLoadingComments) return;
    if (refresh) {
      userComments = [];
      commentsPage = 1;
      hasMoreComments = true;
    }
    if (!hasMoreComments) return;

    setState(() {
      isLoadingComments = true;
    });

    final networkService = Provider.of<NetworkService>(context, listen: false);
    final comments = await networkService.fetchUserComments(
      widget.userName,
      page: commentsPage,
      limit: 20, // or another appropriate limit
    );

    setState(() {
      if (comments != null && comments.isNotEmpty) {
        userComments.addAll(comments);
        commentsPage++;
      } else {
        hasMoreComments = false;
      }
      isLoadingComments = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
    fetchUserComments();
  }

  /// Formats the cake day string to a readable format.
  String _formattedCakeDay(String cakeDay) {
    DateTime parsedDate = DateTime.parse(cakeDay);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      body: _buildProfileContent(),
    );
  }

  Widget _buildProfileContent() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          flexibleSpace: Stack(
            children: [
              FlexibleSpaceBar(
                title: Text(
                  widget.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          floating: false,
          pinned: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => ProfileSearch(displayName: widget.displayName, username: widget.userName,),
                  ),
                );
              },
              icon: const Icon(Icons.search, size: 30.0),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share, size: 30.0),
            ),
            PopupMenuButton<Menu>(
              onSelected: (Menu item) {},
              itemBuilder: (BuildContext context) => menuitems(),
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Container(
                height: 190,
                decoration: widget.bannerPicture.isNotEmpty
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.bannerPicture),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.7),
                            BlendMode.dstATop,
                          ),
                        ),
                      )
                    : const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.blue, Colors.black],
                        ),
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
                height: 190,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.profilePicture),
                          radius: 50,
                        ),
                        widget.isOwnProfile
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: EditButton(
                                  userName: widget.userName,
                                ),
                              )
                            : Row(
                                children: [
                                  ChatButton(
                                    userName: widget.userName,
                                    profileName: widget.displayName,
                                  ),
                                  FollowButton(
                                    userName: widget.userName,
                                    profileName: widget.profileName,
                                  ),
                                ],
                              ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'u/${widget.profileName} . ${_formattedCakeDay(widget.cakeDay)}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: widget.about.isNotEmpty
                          ? Text(
                              widget.about,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: const Color.fromARGB(255, 21, 21, 27),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedTab = TabSelection.posts;
                          });
                        },
                        child: Text(
                          'Posts',
                          style: TextStyle(
                            color: widget.selectedTab == TabSelection.posts
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedTab = TabSelection.comments;
                          });
                        },
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            color: widget.selectedTab == TabSelection.comments
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.selectedTab = TabSelection.about;
                          });
                        },
                        child: Text(
                          'About',
                          style: TextStyle(
                            color: widget.selectedTab == TabSelection.about
                                ? Colors.blue
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.selectedTab == TabSelection.posts) ...[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final PostModel postModel = userPosts[index];
                return Post(
                  postModel: postModel,
                  shareNumber: 0,
                  isHomePage: true,
                  isSubRedditPage: false,
                );
              },
              childCount: userPosts.length,
            ),
          ),
        ],
        if (widget.selectedTab == TabSelection.comments) ...[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final comment = userComments[index];
                return UserComment(
                  photo: comment.isImage ? File(comment.content) : null,
                  imageSource: 0,
                  hasVoted:
                      mappingVotes(comment.isUpvoted, comment.isDownvoted),
                      isPostPage: false,
                  comment: userComments[index],
                );
              },
              childCount: userComments.length,
            ),
          ),
        ],
        if (widget.selectedTab == TabSelection.about) ...[
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: const Text("About content here"),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ProfileSearch(displayName: widget.displayName, username: widget.userName,),
              ),
            );
          },
          icon: const Icon(Icons.search, size: 30.0),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.share, size: 30.0),
        ),
        PopupMenuButton<Menu>(
          onSelected: (Menu item) {},
          itemBuilder: (BuildContext context) => menuitems(),
        ),
      ],
    );
  }
}

List<PopupMenuEntry<Menu>> menuitems() {
  return <PopupMenuEntry<Menu>>[
    const PopupMenuItem<Menu>(
      value: Menu.share,
      child: ListTile(
        leading: Icon(Icons.share),
        title: Text('Share'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.subscribe,
      child: ListTile(
        leading: Icon(Icons.add_alert),
        title: Text('Subscribe'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.save,
      child: ListTile(
        leading: Icon(Icons.bookmark_add_outlined),
        title: Text('Save'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.copytext,
      child: ListTile(
        leading: Icon(Icons.copy),
        title: Text('Copy text'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.edit,
      child: ListTile(
        leading: Icon(Icons.edit),
        title: Text('Edit'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.addpostflair,
      child: ListTile(
        leading: Icon(Icons.add),
        title: Text('Add post flair'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.markspoiler,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Mark spoiler'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.markNSFW,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Mark NSFW'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.markasbrandaffiliate,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Mark as brand affiliate'),
      ),
    ),
    const PopupMenuItem<Menu>(
      value: Menu.report,
      child: ListTile(
        leading: Icon(Icons.warning),
        title: Text('Report'),
      ),
    ),
  ];
}
