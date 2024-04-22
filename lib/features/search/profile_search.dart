import 'package:flutter/material.dart';
import 'package:reddit_clone/features/search/post_tile.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

class ProfileSearch extends StatefulWidget {
  const ProfileSearch({super.key, required this.displayName});

  final String displayName;

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
          onChanged: (value) async {
            commentsResults =
                await Provider.of<NetworkService>(context, listen: false)
                    .getSearchComments(value);
            postsResults =
                await Provider.of<NetworkService>(context, listen: false)
                    .getSearchPosts(value);
          },
          onTap: () {},
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
      body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: (_selectedIndex == 0 || _selectedIndex == 2) ? Row(
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
                          child: _selectedIndex == 0 ? ElevatedButton(
                            onPressed: () {},
                            child: const Text("Time"),
                          ) : null,
                        ),
                      ],
                    ) : null,
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
                        //Comments
                        ListView.builder(
                          itemCount: commentsResults.length,
                          itemBuilder: (context, index) {
                            return ListTile();
                          },
                        ),
                        //People
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
