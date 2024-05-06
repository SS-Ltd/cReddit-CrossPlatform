import 'package:flutter/material.dart';
import 'package:reddit_clone/features/comments/comment_page.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/features/search/post_tile.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/search/comment_tile.dart';

class ProfileSearch extends StatefulWidget {
  const ProfileSearch(
      {super.key, required this.displayName, required this.username});

  final String displayName;
  final String username;
  @override
  State<ProfileSearch> createState() {
    return _ProfileSearchState();
  }
}

class _ProfileSearchState extends State<ProfileSearch>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  List<SearchComments> commentsResults = [];
  List<SearchPosts> postsResults = [];
  bool isSearching = true;
  late final TabController _tabController;
  int _selectedIndex = 0;
  String searchQuery = '';
  final FocusNode _focusNode = FocusNode();
  String sortOption = "Most relevant";
  String timeOption = "All time";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) async {
            commentsResults =
                await Provider.of<NetworkService>(context, listen: false)
                    .getSearchComments(value, widget.username, sortOption);
            postsResults = await Provider.of<NetworkService>(context,
                    listen: false)
                .getSearchPosts(value, widget.username, sortOption, timeOption);
            setState(() {
              isSearching = false;
              searchQuery = value;
            });
          },
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
            contentPadding: const EdgeInsets.all(10),
          ),
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
                    text: "Comments",
                  ),
                ],
              ),
      ),
      body: isSearching
          ? const Column()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            RadioListTile(
                                              title:
                                                  const Text("Most relevant"),
                                              value: 'Most relevant',
                                              groupValue: sortOption,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    sortOption =
                                                        value.toString();
                                                  },
                                                );
                                                Navigator.pop(context);
                                              },
                                            ),
                                            RadioListTile(
                                              title: const Text("Hot"),
                                              value: 'Hot',
                                              groupValue: sortOption,
                                              onChanged: (value) {
                                                setState(
                                                  () {
                                                    sortOption =
                                                        value.toString();
                                                  },
                                                );
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
                                                    sortOption =
                                                        value.toString();
                                                  },
                                                );
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
                                                    sortOption =
                                                        value.toString();
                                                  },
                                                );
                                                Navigator.pop(context);
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
                                                    "Filter by time",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  RadioListTile(
                                                    title:
                                                        const Text("All time"),
                                                    value: 'All time',
                                                    groupValue: timeOption,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          timeOption =
                                                              value.toString();
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title:
                                                        const Text("Past year"),
                                                    value: 'Past year',
                                                    groupValue: timeOption,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          timeOption =
                                                              value.toString();
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title: const Text(
                                                        "Past month"),
                                                    value: 'Past month',
                                                    groupValue: timeOption,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          timeOption =
                                                              value.toString();
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title:
                                                        const Text("Past week"),
                                                    value: 'Past week',
                                                    groupValue: timeOption,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          timeOption =
                                                              value.toString();
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title: const Text(
                                                        "Past 24 hours"),
                                                    value: 'Past 24 hours',
                                                    groupValue: timeOption,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          timeOption =
                                                              value.toString();
                                                        },
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  RadioListTile(
                                                    title:
                                                        const Text("Past hour"),
                                                    value: 'Past hour',
                                                    groupValue: timeOption,
                                                    onChanged: (value) {
                                                      setState(
                                                        () {
                                                          timeOption =
                                                              value.toString();
                                                        },
                                                      );
                                                      Navigator.pop(context);
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
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      postsResults.isEmpty
                          ? noResults()
                          : ListView.builder(
                              itemCount: postsResults.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    Post postComment = Post(
                                      postModel: await Provider.of<
                                                  NetworkService>(context,
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
                                          username:
                                              postsResults[index].username,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      PostTile(
                                          post: postsResults[index],
                                          isProfile: true),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                      //Comments
                      commentsResults.isEmpty
                          ? noResults()
                          : ListView.builder(
                              itemCount: commentsResults.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    CommentTile(
                                        comment: commentsResults[index],
                                        isProfile: true),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
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
        ElevatedButton(
          onPressed: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: const Text('Adjust Search'),
        ),
      ],
    );
  }
}
