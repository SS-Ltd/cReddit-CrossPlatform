import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reddit_clone/features/search/post_tile.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:provider/provider.dart';
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

  String sortOption = '';
  String timeOption = '';
  String searchQuery = '';
  bool isSearching = true;
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                    )
                  ],
                ),
        ),
        body: isSearching
            ? Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: commentsResults.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // leading: CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //       commentsResults[index].postPicture),
                          // ),
                          title: Text(commentsResults[index].postTitle),
                          onTap: () {
                            // Navigate to the post and add to recently search
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
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            isSearching = false;
                          },
                        );
                      },
                      child: Text('Search for $searchQuery'),
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
                            return Column(
                              children: [
                                PostTile(post: postsResults[index]),
                                const Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                        //Communities
                        ListView.builder(
                          itemCount: commentsResults.length,
                          itemBuilder: (context, index) {
                            Community community = Community(
                                name: communitiesResults[index].name,
                                description: communitiesResults[index].description,
                                members: communitiesResults[index].members,
                                icon: communitiesResults[index].icon,
                                isJoined: false);
                            return const Column(
                              children: [
                                Divider(
                                  thickness: 1,
                                ),
                              ],
                            );
                          },
                        ),
                        //Comments
                        ListView.builder(
                          itemCount: commentsResults.length,
                          itemBuilder: (context, index) {
                            return ListTile();
                          },
                        ),
                        //People
                        ListView.builder(
                          itemCount: peopleResults.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        peopleResults[index].profilePicture),
                                  ),
                                  title: Text(
                                      'u/${peopleResults[index].username}'),
                                  subtitle: const Text('cake'),
                                  trailing: const Text('follow button'),
                                ),
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
      ),
    );
  }
}
