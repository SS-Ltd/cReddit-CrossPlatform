import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/post.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/services/networkServices.dart';

class SubRedditPage extends StatefulWidget {
  final String? subredditName;

  const SubRedditPage({super.key, required this.subredditName});

  @override
  State<SubRedditPage> createState() => _SubRedditPageState();
}

class _SubRedditPageState extends State<SubRedditPage> {
  bool isJoined = false;
  String currentSort = 'Hot';
  String currentIcon = 'Hot';
  List<String> posts = List.generate(20, (index) => 'Post $index');
  List<PostModel> subredditPosts = [];

  String _subredditIcon = '';
  String _subredditBanner = 'https://picsum.photos/200/300';
  String _subredditDescription = '';
  int _subredditMembers = 0;
  List<String> _subredditRules = [];
  List<String> _subredditModerators = [];
  @override
  void initState() {
    super.initState();
    fetchSubredditDetails();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final subredditName = widget.subredditName;
    final posts = await networkService.fetchPostsForSubreddit2(subredditName);

    if (posts != null) {
      setState(() {
        subredditPosts = posts;
      });
    }
  }

  Future<void> fetchSubredditDetails() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    for (var subreddit in networkService.user?.recentlyVisited ?? []) {
      print(subreddit.name);
    }
    final details =
        await networkService.getSubredditDetails(widget.subredditName);
    if (details != null) {
      networkService.user?.recentlyVisited.add(details);
      setState(() {
        print(details.icon);
        _subredditIcon = details.icon;
        _subredditBanner = details.banner ?? 'https://picsum.photos/200/300';
        //  _subredditDescription = details['description'];
        _subredditMembers = details.members;
        _subredditRules = details.rules;
        _subredditModerators = details.moderators;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          title: Text('r/${widget.subredditName}',
              style: const TextStyle(color: Colors.white)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_subredditBanner),
                fit: BoxFit.cover,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            _iconButtonWithBackground(Icons.search, () {}),
            _iconButtonWithBackground(Icons.share_outlined, () {}),
            _iconButtonWithBackground(Icons.more_vert, () {}),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _subredditInfo()),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
            ),
          ),
          SliverToBoxAdapter(child: _sortingOptions()),
          // Inside CustomScrollView
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // Use the postWidget method to create a widget for each post
                return postWidget(subredditPosts[index]);
              },
              childCount: subredditPosts
                  .length, // Set the count to the length of subredditPosts
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
          postType: postModel.type,  
          profilePicture: postModel.profilePicture,
          content: postModel.content,
          commentNumber: postModel.commentCount,
          shareNumber: 0, // Adjust accordingly if your model includes this info
          timeStamp: postModel.uploadDate ?? DateTime.now(),
          isHomePage: true,
          isSubRedditPage: true,
          postId: postModel.postId,
          votes: postModel.netVote,
          isDownvoted: postModel.isDownvoted,
          isUpvoted: postModel.isUpvoted,
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  Widget _sortingOptions() {
    return ListTile(
      title: Row(
        children: [
          if (currentSort == 'Hot')
            const Icon(Icons.whatshot_outlined, color: Colors.white),
          if (currentSort == 'New')
            const Icon(Icons.new_releases_outlined, color: Colors.white),
          if (currentSort == 'Top')
            const Icon(Icons.arrow_upward_outlined, color: Colors.white),
          const SizedBox(width: 8),
          Text(currentSort, style: const TextStyle(color: Colors.white)),
        ],
      ),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: const Color.fromARGB(255, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _sortingOptionTile('Hot', Icons.whatshot_outlined, () {
                    setState(() {
                      currentSort = 'Hot';
                    });
                    Navigator.pop(context);
                  }),
                  _sortingOptionTile('New', Icons.new_releases_outlined, () {
                    setState(() {
                      currentSort = 'New';
                    });
                    Navigator.pop(context);
                  }),
                  _sortingOptionTile('Top', Icons.arrow_upward_outlined, () {
                    setState(() {
                      currentSort = 'Top';
                    });
                    Navigator.pop(context);
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sortingOptionTile(String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _subredditInfo() {
    print('Subreddit Icon URL: $_subredditIcon');
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color.fromRGBO(27, 27, 27, 1),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: _subredditIcon.isNotEmpty
                    ? NetworkImage(_subredditIcon)
                    : const NetworkImage('https://picsum.photos/200/300'),
                radius: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('r/${widget.subredditName}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    Row(
                      children: [
                        Text('$_subredditMembers members  ',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white)),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('$_subredditMembers online',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    isJoined = !isJoined;
                  });
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                ),
                child: Text(isJoined ? 'Joined' : 'Join',
                    style: const TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Welcome to the official subreddit of the osama.'
            ' This is a place for all things osama.',
            //to be replaced with description when its done in backend
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _iconButtonWithBackground(IconData icon, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.black45, // Semi-transparent black
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
