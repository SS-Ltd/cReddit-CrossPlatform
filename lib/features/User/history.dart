import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';

/// A page that displays the user's history.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<PostModel> historyPosts = [];
  String currentSort = 'Recent';
  IconData currentIcon = Icons.access_time;
  bool isLoading = false;
  int page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    fetchHistory(currentSort);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Fetches the user's history based on the specified sort option.
  void fetchHistory(String sort) async {
    if (isLoading) return; // Prevent multiple simultaneous loads
    setState(() {
      isLoading = true; // Start loading
    });

    List<PostModel>? newPosts;
    switch (sort) {
      case 'Recent':
        newPosts = await Provider.of<NetworkService>(context, listen: false)
            .getUserHistory(page: page);
        break;
      case 'Upvoted':
        newPosts = await Provider.of<NetworkService>(context, listen: false)
            .getUpvotedPosts(page: page);
        break;
      case 'Downvoted':
        newPosts = await Provider.of<NetworkService>(context, listen: false)
            .getDownvotedPosts(page: page);
        break;
      case 'Hidden':
        newPosts = await Provider.of<NetworkService>(context, listen: false)
            .getHiddenPosts(page: page);
        break;
    }

    if (newPosts != null && newPosts.isNotEmpty) {
      setState(() {
        historyPosts
            .addAll(newPosts as Iterable<PostModel>); // Append new posts
        page++; // Increase the page count for next API call
      });
    }
    setState(() {
      isLoading = false; // Finish loading
    });
  }

  /// Callback function for scroll events.
  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchHistory(currentSort); // Load more posts if at the bottom
    }
  }

  /// Shows the sort options in a bottom sheet.
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Sort History By",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            _sortingOptionTile('Recent', Icons.access_time, 'Recent'),
            _sortingOptionTile('Upvoted', Icons.thumb_up, 'Upvoted'),
            _sortingOptionTile('Downvoted', Icons.thumb_down, 'Downvoted'),
            _sortingOptionTile('Hidden', Icons.visibility_off, 'Hidden'),
          ],
        );
      },
    );
  }

  /// Updates the sorting option and fetches the corresponding history.
  void _updateSorting(String sortOption, IconData icon) {
    if (currentSort != sortOption) {
      setState(() {
        currentSort = sortOption;
        currentIcon = icon;
        historyPosts.clear(); // Clear posts for new sort type
        page = 1; // Reset pagination
      });
      fetchHistory(sortOption);
    }
    Navigator.pop(context); // Close the bottom sheet
  }

  /// Builds a ListTile for a sorting option.
  Widget _sortingOptionTile(String title, IconData icon, String sortKey) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: () => _updateSorting(sortKey, icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(currentIcon, color: Colors.grey),
            title:
                Text(currentSort, style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            onTap: _showSortOptions,
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: historyPosts.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < historyPosts.length) {
                  return postWidget(historyPosts[index]);
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a widget for a post.
  Widget postWidget(PostModel postModel) {
    return Column(
      children: [
        Post(
          postModel: postModel,
          shareNumber: 0,
          isHomePage: true,
          isSubRedditPage: false,
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
