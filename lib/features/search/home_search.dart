import 'package:flutter/material.dart';
import 'package:reddit_clone/features/User/follow_unfollow_button.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/community/community_card.dart';
import 'package:reddit_clone/features/community/subreddit_page.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/features/search/comment_tile.dart';
import 'package:reddit_clone/features/search/post_tile.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';

//this page will be used to search inside home and communities page

class HomeSearch extends StatefulWidget {
  const HomeSearch({super.key});

  @override
  State<HomeSearch> createState() {
    return _HomeSearchState();
  }
}

class _HomeSearchState extends State<HomeSearch>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();

  List<SearchComments> commentsResults = [];
  List<SearchPosts> postsResults = [];
  List<SearchCommunities> communitiesResults = [];
  List<SearchUsers> peopleResults = [];
  List<SearchHashtag> hashtagsResults = [];

  String sortOption = '';
  String timeOption = '';
  String searchQuery = '';
  bool isSearching = true;
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Reddit',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(Icons.clear),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
              contentPadding: const EdgeInsets.all(10),
            ),
            onChanged: (value) async {
              setState(() {
                searchQuery = value;
              });
              commentsResults =
                  await Provider.of<NetworkService>(context, listen: false)
                      .getSearchComments(value, '');
              postsResults =
                  await Provider.of<NetworkService>(context, listen: false)
                      .getSearchPosts(value, '');
              communitiesResults =
                  await Provider.of<NetworkService>(context, listen: false)
                      .getSearchCommunities(value);
              peopleResults =
                  await Provider.of<NetworkService>(context, listen: false)
                      .getSearchUsers(value);
              hashtagsResults =
                  await Provider.of<NetworkService>(context, listen: false)
                      .getSearchHashtags(value);
            },
            onTap: () {
              setState(() {
                isSearching = true;
              });
            },
          ),
          bottom: isSearching
              ? null
              : TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(
                      text: "Posts",
                    ),
                    Tab(
                      text: "Communities",
                    ),
                    Tab(
                      text: "Comments",
                    ),
                    Tab(
                      text: "People",
                    ),
                    Tab(
                      text: "Hashtags",
                    ),
                  ],
                ),
        ),
        body: isSearching
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (communitiesResults.isNotEmpty) const Text('Communities'),
                  if (communitiesResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: communitiesResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(communitiesResults[index].icon),
                            ),
                            subtitle: Text(
                                "${communitiesResults[index].members} members"),
                            title: Text(communitiesResults[index].name),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubRedditPage(
                                    subredditName:
                                        communitiesResults[index].name,
                                  ),
                                ),
                              );
                            },
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.clear),
                            ),
                          );
                        },
                      ),
                    ),
                  if (peopleResults.isNotEmpty) const Text('People'),
                  if (peopleResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: peopleResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  peopleResults[index].profilePicture),
                            ),
                            title: Text(peopleResults[index].username),
                            onTap: () async {
                              UserModel myUser = await context
                                  .read<NetworkService>()
                                  .getMyDetails();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomNavigationBar(
                                    isProfile: true,
                                    myuser: myUser,
                                  ),
                                ),
                              );
                            },
                            trailing: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.clear),
                            ),
                          );
                        },
                      ),
                    ),
                  if (searchQuery.isNotEmpty)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(
                            () {
                              isSearching = false;
                            },
                          );
                        },
                        child: Text(
                          'Search for $searchQuery',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: (_selectedIndex == 0 || _selectedIndex == 2)
                        ? Row(
                            children: [
                              SizedBox(
                                width: 90,
                                height: 35,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BottomSheet(
                                          onClosing: () {},
                                          builder: (BuildContext context) {
                                            return const Column(
                                              children: [],
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Sort"),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 90,
                                height: 35,
                                child: _selectedIndex == 0
                                    ? ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Time"),
                                      )
                                    : null,
                              ),
                            ],
                          )
                        : null,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        //Posts
                        ListView.builder(
                          itemCount: postsResults.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                Post postComment = Post(
                                  postModel: await Provider.of<NetworkService>(
                                          context,
                                          listen: false)
                                      .fetchPost(postsResults[index].id),
                                  isHomePage: false,
                                  isSubRedditPage: false,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CommentPage(
                                      postId: postsResults[index].id,
                                      postComment: postComment,
                                      postTitle: postsResults[index].title,
                                      username: postsResults[index].username,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  PostTile(
                                      post: postsResults[index],
                                      isProfile: false),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        //Communities
                        ListView.builder(
                          itemCount: communitiesResults.length,
                          itemBuilder: (context, index) {
                            Community community = Community(
                                name: communitiesResults[index].name,
                                description:
                                    communitiesResults[index].description,
                                members: communitiesResults[index].members,
                                icon: communitiesResults[index].icon,
                                isJoined: false);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubRedditPage(
                                      subredditName:
                                          communitiesResults[index].name,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CommunityCard(
                                      community: community, search: true),
                                  const Divider(
                                    thickness: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        //Comments
                        ListView.builder(
                          itemCount: commentsResults.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CommentTile(
                                    comment: commentsResults[index],
                                    isProfile: false),
                                const Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                        //People
                        ListView.builder(
                          itemCount: peopleResults.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    UserModel myUser = await context
                                        .read<NetworkService>()
                                        .getMyDetails();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomNavigationBar(
                                          isProfile: true,
                                          myuser: myUser,
                                        ),
                                      ),
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        peopleResults[index].profilePicture),
                                  ),
                                  title: Text(
                                      'u/${peopleResults[index].username}'),
                                  subtitle: const Text('cake'),
                                  trailing: FollowButton(
                                      userName: 'userName',
                                      profileName:
                                          peopleResults[index].username),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                        //Hashtags
                        ListView.builder(
                          itemCount: hashtagsResults.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: () async {
                                    UserModel myUser = await context
                                        .read<NetworkService>()
                                        .getMyDetails();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomNavigationBar(
                                          isProfile: true,
                                          myuser: myUser,
                                        ),
                                      ),
                                    );
                                  },
                                  // leading: CircleAvatar(
                                  //   backgroundImage: NetworkImage(
                                  //       hashtagsResults[index].profilePicture),
                                  // ),
                                  title: Text(
                                      'u/${hashtagsResults[index].username}'),
                                  subtitle: const Text('cake'),
                                  trailing: FollowButton(
                                      userName: 'userName',
                                      profileName:
                                          hashtagsResults[index].username),
                                ),
                                const Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),

                        ///
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
