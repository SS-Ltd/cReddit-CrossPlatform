// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reddit_clone/common/CustomLoadingIndicator.dart';
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
  final ScrollController _scrollController = ScrollController();

  List<SearchComments> commentsResults = [];
  List<SearchPosts> postsResults = [];
  List<SearchCommunities> communitiesResults = [];
  List<SearchUsers> peopleResults = [];
  List<dynamic> hashtagsResults = [];

  String sortOption = "Hot";
  String timeOption = "All";
  String searchQuery = '';
  bool isSearching = true;
  bool isLoading = false;
  bool isGettingMoreData = false;
  bool canRequestFocus = true;
  late final TabController _tabController;
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  int commentsPage = 1;
  int postsPage = 1;
  int communitiesPage = 1;
  int peoplePage = 1;
  int hashtagsPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          50.0) {
        print("new data");
        // The user has scrolled to the end of the list, fetch more data
        switch (_selectedIndex) {
          case 0:
            getPostsData();
            break;
          case 1:
            getCommunitiesData();
            break;
          case 2:
            getCommentsData();
            break;
          case 3:
            getUsersData();
            break;
          case 4:
            getHashtagsData();
            break;
        }
      }
    });
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void getCommentsData() async {
    setState(() {
      isGettingMoreData = true; // Start loading
    });
    List<SearchComments> newComments =
        await Provider.of<NetworkService>(context, listen: false)
            .getSearchComments(
                searchQuery, '', sortOption, "", commentsPage, "");
    setState(() {
      commentsResults.addAll(newComments);
      isGettingMoreData = false; // End loading
      commentsPage++; // Increment page number
    });
  }

  void getPostsData() async {
    setState(() {
      isGettingMoreData = true; // Start loading
    });
    List<SearchPosts> newPosts = await Provider.of<NetworkService>(context,
            listen: false)
        .getSearchPosts(searchQuery, '', sortOption, timeOption, postsPage, "");
    setState(() {
      postsResults.addAll(newPosts);
      isGettingMoreData = false; // End loading
      postsPage++; // Increment page number
    });
  }

  void getCommunitiesData() async {
    setState(() {
      isGettingMoreData = true; // Start loading
    });
    List<SearchCommunities> newCommunities =
        await Provider.of<NetworkService>(context, listen: false)
            .getSearchCommunities(searchQuery, true, communitiesPage);
    setState(() {
      communitiesResults.addAll(newCommunities);
      isGettingMoreData = false; // End loading
      communitiesPage++; // Increment page number
    });
  }

  void getUsersData() async {
    setState(() {
      isGettingMoreData = true; // Start loading
    });
    List<SearchUsers> newUsers =
        await Provider.of<NetworkService>(context, listen: false)
            .getSearchUsers(searchQuery, peoplePage);
    setState(() {
      peopleResults.addAll(newUsers);
      isGettingMoreData = false; // End loading
      peoplePage++; // Increment page number
    });
  }

  void getHashtagsData() async {
    setState(() {
      isGettingMoreData = true; // Start loading
    });
    List<dynamic> newHashtags =
        await Provider.of<NetworkService>(context, listen: false)
            .getSearchHashtags(searchQuery, hashtagsPage, "", "");
    setState(() {
      hashtagsResults.addAll(newHashtags);
      isGettingMoreData = false; // End loading
      hashtagsPage++; // Increment page number
    });
  }

  void getAllData() async {
    setState(() {
      isLoading = true; // Start loading
    });
    commentsResults = await Provider.of<NetworkService>(context, listen: false)
        .getSearchComments(searchQuery, '', sortOption, timeOption, 1, "");
    postsResults = await Provider.of<NetworkService>(context, listen: false)
        .getSearchPosts(searchQuery, '', sortOption, timeOption, 1, "");
    communitiesResults =
        await Provider.of<NetworkService>(context, listen: false)
            .getSearchCommunities(searchQuery, true, 1);
    peopleResults = await Provider.of<NetworkService>(context, listen: false)
        .getSearchUsers(searchQuery, 1);
    hashtagsResults = await Provider.of<NetworkService>(context, listen: false)
        .getSearchHashtags(searchQuery, 1, "", "");

    print(searchQuery + "  " + sortOption);
    setState(() {
      isLoading = false; // End loading
    });
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
            icon: Semantics(
                label: 'go back',
                identifier: 'go back',
                child: const Icon(Icons.arrow_back)),
          ),
          title: Semantics(
            label: "search text",
            identifier: "search text",
            child: TextField(
              canRequestFocus: true,
              focusNode: _focusNode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Reddit',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: Semantics(
                      label: 'cancel',
                      identifier: 'cancel',
                      child: const Icon(Icons.clear)),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                contentPadding: const EdgeInsets.all(10),
              ),
              onChanged: (value) async {
                if (!mounted) return;

                setState(() {
                  searchQuery = value;
                });
                if (value.isEmpty) {
                  setState(() {
                    commentsResults.clear();
                    postsResults.clear();
                    communitiesResults.clear();
                    peopleResults.clear();
                    hashtagsResults.clear();
                  });
                  return;
                }
                getAllData();
              },
              onTap: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          ),
          bottom: isSearching
              ? null
              : TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: const <Widget>[
                    SizedBox(
                      width: 40,
                      child: Tab(text: "Posts"),
                    ),
                    SizedBox(
                      width: 100,
                      child: Tab(
                        text: "Communities",
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Tab(
                        text: "Comments",
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Tab(
                        text: "People",
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Tab(
                        text: "Hashtags",
                      ),
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
                        controller: _scrollController,
                        itemCount: communitiesResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage(communitiesResults[index].icon),
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
                              icon: Semantics(
                                  label: 'clear1',
                                  identifier: 'clear1',
                                  child: const Icon(Icons.clear)),
                            ),
                          );
                        },
                      ),
                    ),
                  if (peopleResults.isNotEmpty) const Text('People'),
                  if (peopleResults.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: peopleResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
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
                              icon: Semantics(
                                  identifier: 'clear2',
                                  label: 'clear2',
                                  child: const Icon(Icons.clear)),
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
                                    _focusNode.unfocus();
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            BottomSheet(
                                              onClosing: () {},
                                              builder: (BuildContext context) {
                                                return Column(
                                                  children: [
                                                    const Text(
                                                      "Sort by",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    RadioListTile(
                                                      title: const Text("Hot"),
                                                      value: 'Hot',
                                                      groupValue: sortOption,
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            sortOption = value
                                                                .toString();
                                                          },
                                                        );
                                                        getAllData();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    RadioListTile(
                                                      title: const Text("Top"),
                                                      value: 'Top',
                                                      groupValue: sortOption,
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            sortOption = value
                                                                .toString();
                                                          },
                                                        );
                                                        getAllData();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    RadioListTile(
                                                      title: const Text("New"),
                                                      value: 'New',
                                                      groupValue: sortOption,
                                                      onChanged: (value) {
                                                        setState(
                                                          () {
                                                            sortOption = value
                                                                .toString();
                                                          },
                                                        );
                                                        getAllData();
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
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
                                        onPressed: () {
                                          _focusNode.unfocus();
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  BottomSheet(
                                                    onClosing: () {},
                                                    builder:
                                                        (BuildContext context) {
                                                      return Column(
                                                        children: [
                                                          const Text(
                                                            "Filter by time",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                          ),
                                                          RadioListTile(
                                                            title: const Text(
                                                                "Now"),
                                                            value: 'Now',
                                                            groupValue:
                                                                timeOption,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  timeOption = value
                                                                      .toString();
                                                                },
                                                              );
                                                              getAllData();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            title: const Text(
                                                                "Today"),
                                                            value: 'Today"),',
                                                            groupValue:
                                                                timeOption,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  timeOption = value
                                                                      .toString();
                                                                },
                                                              );
                                                              getAllData();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            title: const Text(
                                                                "Week"),
                                                            value: 'Week',
                                                            groupValue:
                                                                timeOption,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  timeOption = value
                                                                      .toString();
                                                                },
                                                              );
                                                              getAllData();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            title: const Text(
                                                                "Month"),
                                                            value: 'Month',
                                                            groupValue:
                                                                timeOption,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  timeOption = value
                                                                      .toString();
                                                                },
                                                              );
                                                              getAllData();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            title: const Text(
                                                                "Year"),
                                                            value: 'Year',
                                                            groupValue:
                                                                timeOption,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  timeOption = value
                                                                      .toString();
                                                                },
                                                              );
                                                              getAllData();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                          RadioListTile(
                                                            title: const Text(
                                                                "All"),
                                                            value: 'All',
                                                            groupValue:
                                                                timeOption,
                                                            onChanged: (value) {
                                                              setState(
                                                                () {
                                                                  timeOption = value
                                                                      .toString();
                                                                },
                                                              );
                                                              getAllData();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
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
                        postsResults.isEmpty && !isLoading
                            ? noResults()
                            : isLoading
                                ? const CustomLoadingIndicator()
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: postsResults.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          Post postComment = Post(
                                            postModel: await Provider.of<
                                                        NetworkService>(context,
                                                    listen: false)
                                                .fetchPost(
                                                    postsResults[index].id),
                                            isHomePage: false,
                                            isSubRedditPage: false,
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CommentPage(
                                                postId: postsResults[index].id,
                                                postComment: postComment,
                                                postTitle:
                                                    postsResults[index].title,
                                                username: postsResults[index]
                                                    .username,
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
                        communitiesResults.isEmpty && !isLoading
                            ? noResults()
                            : isLoading
                                ? const CustomLoadingIndicator()
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: communitiesResults.length,
                                    itemBuilder: (context, index) {
                                      Community community = Community(
                                          name: communitiesResults[index].name,
                                          description: communitiesResults[index]
                                              .description,
                                          members:
                                              communitiesResults[index].members,
                                          icon: communitiesResults[index].icon,
                                          isJoined: false);
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SubRedditPage(
                                                subredditName:
                                                    communitiesResults[index]
                                                        .name,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            CommunityCard(
                                                community: community,
                                                search: true),
                                            const Divider(
                                              thickness: 1,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                        //Comments
                        commentsResults.isEmpty && !isLoading
                            ? noResults()
                            : isLoading
                                ? const CustomLoadingIndicator()
                                : ListView.builder(
                                    controller: _scrollController,
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
                        peopleResults.isEmpty && !isLoading
                            ? noResults()
                            : isLoading
                                ? const CustomLoadingIndicator()
                                : ListView.builder(
                                    controller: _scrollController,
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
                                              backgroundImage: AssetImage(
                                                  peopleResults[index]
                                                      .profilePicture),
                                            ),
                                            title: Text(
                                                'u/${peopleResults[index].username}'),
                                            trailing: FollowButton(
                                                userName: 'userName',
                                                profileName:
                                                    peopleResults[index]
                                                        .username),
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                        //Hashtags
                        hashtagsResults.isEmpty && !isLoading
                            ? noResults()
                            : isLoading
                                ? CustomLoadingIndicator()
                                : ListView.builder(
                                    controller: _scrollController,
                                    itemCount: hashtagsResults.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          if (hashtagsResults[index]
                                              is SearchHashTagPost)
                                            ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  hashtagsResults[index]
                                                      .commentPicture,
                                                ),
                                              ),
                                              title: Text(hashtagsResults[index]
                                                  .username),
                                              subtitle: Text(
                                                  hashtagsResults[index]
                                                      .postTitle),
                                              onTap: () async {
                                                Post postComment = Post(
                                                  postModel: await Provider.of<
                                                              NetworkService>(
                                                          context,
                                                          listen: false)
                                                      .fetchPost(
                                                          hashtagsResults[index]
                                                              .id),
                                                  isHomePage: false,
                                                  isSubRedditPage: false,
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CommentPage(
                                                      postId:
                                                          hashtagsResults[index]
                                                              .id,
                                                      postComment: postComment,
                                                      postTitle:
                                                          hashtagsResults[index]
                                                              .postTitle,
                                                      username:
                                                          hashtagsResults[index]
                                                              .username,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          if (hashtagsResults[index]
                                              is SearchComments)
                                            CommentTile(
                                                comment: hashtagsResults[index],
                                                isProfile: false),
                                          const Divider(
                                            thickness: 1,
                                          )
                                        ],
                                      );
                                    },
                                  ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget noResults() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 200,
          child: Image.asset(
            'assets/search.png',
            fit: BoxFit.contain,
          ),
        ),
        const Text(
          "Hm...we couldn't find any",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(
          'results for "$searchQuery"',
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const Text('Double-check your spelling or try a different keywords'),
      ],
    );
  }
}
