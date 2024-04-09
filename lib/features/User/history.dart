import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/NetworkServices.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<PostModel>? historyPosts;
  String currentSort = 'Recent';
  IconData currentIcon = Icons.access_time;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  void fetchHistory() async {
    final posts = await Provider.of<NetworkService>(context, listen: false)
        .getUserHistory();
    if (posts != null) {
      setState(() => historyPosts = posts);
    }
  }

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
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            _sortingOptionTile('Recent', Icons.access_time, () {
              _updateSorting('Recent', Icons.access_time);
            }),
            _sortingOptionTile('Upvoted', Icons.thumb_up, () {
              _updateSorting('Upvoted', Icons.thumb_up);
            }),
            _sortingOptionTile('Downvoted', Icons.thumb_down, () {
              _updateSorting('Downvoted', Icons.thumb_down);
            }),
          ],
        );
      },
    );
  }

  void _updateSorting(String sortOption, IconData icon) {
    setState(() {
      currentSort = sortOption;
      currentIcon = icon;
    });
    Navigator.pop(context); // Close the modal bottom sheet
  }

  Widget _sortingOptionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
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
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentSort, style: const TextStyle(color: Colors.grey)),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
            onTap: _showSortOptions,
          ),
          Expanded(
            child: historyPosts == null
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: historyPosts!.length,
                    itemBuilder: (context, index) {
                      // Assuming you have a widget to display each post
                      return postWidget(historyPosts![index]);
                    },
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
          communityName: postModel.communityName ?? '',
          userName: postModel.username,
          title: postModel.title,
          profilePicture: postModel.profilePicture,
          imageUrl: '', // Assuming this is the image URL
          content: postModel.content,
          commentNumber: postModel.commentCount,
          shareNumber: 0, // Adjust accordingly if your model includes this info
          timeStamp: postModel.uploadDate,
          isHomePage: true, // Adjust based on your design/requirements
          isSubRedditPage: false, 
          postId: postModel.postId,
          votes: postModel.netVote,
          isDownvoted: postModel.isDownvoted,
          isUpvoted: postModel.isUpvoted,
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
