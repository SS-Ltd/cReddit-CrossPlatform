import 'package:flutter/material.dart';
import 'package:reddit_clone/features/search/post_tile.dart';
import 'package:reddit_clone/models/search.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

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
                    .getSearchComments(value, widget.username);
            postsResults =
                await Provider.of<NetworkService>(context, listen: false)
                    .getSearchPosts(value, widget.username);
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
          ? Column()
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
                                return Column(
                                  children: [
                                    PostTile(
                                        post: postsResults[index],
                                        isProfile: true),
                                    const Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                      //Comments
                      commentsResults.isEmpty
                          ? noResults()
                          : ListView.builder(
                              itemCount: commentsResults.length,
                              itemBuilder: (context, index) {
                                return ListTile();
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
