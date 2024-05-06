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

class GeneralSearch extends StatefulWidget {
  const GeneralSearch(
      {super.key,
      required this.communityName,
      required this.displayName,
      required this.username});

  final String communityName;
  final String displayName;
  final String username;

  @override
  State<GeneralSearch> createState() {
    return _GeneralSearchState();
  }
}

class _GeneralSearchState extends State<GeneralSearch>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<SearchComments> commentsResults = [];
  List<SearchPosts> postsResults = [];
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
            getCommentsData();
            break;
          case 2:
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
            .getSearchComments(searchQuery, widget.username, sortOption, "",
                commentsPage, widget.communityName);
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
    List<SearchPosts> newPosts =
        await Provider.of<NetworkService>(context, listen: false)
            .getSearchPosts(searchQuery, widget.username, sortOption,
                timeOption, postsPage, widget.communityName);
    setState(() {
      postsResults.addAll(newPosts);
      isGettingMoreData = false; // End loading
      postsPage++; // Increment page number
    });
  }

  void getHashtagsData() async {
    setState(() {
      isGettingMoreData = true; // Start loading
    });
    List<dynamic> newHashtags = await Provider.of<NetworkService>(context,
            listen: false)
        .getSearchHashtags(
            searchQuery, hashtagsPage, widget.username, widget.communityName);
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
        .getSearchComments(searchQuery, widget.username, sortOption, "", 1,
            widget.communityName);
    postsResults = await Provider.of<NetworkService>(context, listen: false)
        .getSearchPosts(searchQuery, widget.username, sortOption, timeOption, 1,
            widget.communityName);
    hashtagsResults = await Provider.of<NetworkService>(context, listen: false)
        .getSearchHashtags(
            searchQuery, 1, widget.username, widget.communityName);

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
            icon: const Icon(Icons.arrow_back),
          ),
          title: TextField(
            canRequestFocus: true,
            focusNode: _focusNode,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search ${widget.displayName}',
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
              if (!mounted) return;

              setState(() {
                searchQuery = value;
              });
              if (value.isEmpty) {
                setState(() {
                  commentsResults.clear();
                  postsResults.clear();
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
                      width: 80,
                      child: Tab(
                        text: "Comments",
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
                        //Hashtags
                        hashtagsResults.isEmpty && !isLoading
                            ? noResults()
                            : isLoading
                                ? const CustomLoadingIndicator()
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
                                                backgroundImage: NetworkImage(
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
