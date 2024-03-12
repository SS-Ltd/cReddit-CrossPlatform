import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class SubRedditPage extends StatefulWidget {
  const SubRedditPage({super.key});

  @override
  State<SubRedditPage> createState() => _SubRedditPageState();
}

class _SubRedditPageState extends State<SubRedditPage> {
  bool isJoined = false;
  String currentSort = 'Hot';
  String currentIcon = 'Hot';
  List<String> posts = List.generate(20, (index) => 'Post $index');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          title: Text('r/SubredditName', style: TextStyle(color: Colors.white)),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://picsum.photos/200/300'),
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
            ),
          ),
          SliverToBoxAdapter(child: _sortingOptions()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text(posts[index]),
                  subtitle: Text('Post Summary Here'),
                  trailing: Icon(Icons.comment),
                  leading: Icon(Icons.image),
                  onTap: () {},
                );
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
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
          SizedBox(width: 8),
          Text(currentSort, style: TextStyle(color: Colors.white)),
        ],
      ),
      trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: const Color.fromRGBO(27, 27, 27, 1),
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
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _subredditInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color.fromRGBO(27, 27, 27, 1),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/50/50'),
                radius: 25,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('r/hi osama',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white)),
                    Row(
                      children: [
                        const Text('100 members  ',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
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
                            const Text('200 online',
                                style: TextStyle(
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
            'Welcome to the official subreddit of the osama. This is a place for all things osama.',
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
