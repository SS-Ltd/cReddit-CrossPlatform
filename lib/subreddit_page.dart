import 'package:flutter/material.dart';

class SubRedditPage extends StatefulWidget {
  const SubRedditPage({super.key});

  @override
  State<SubRedditPage> createState() => _SubRedditPageState();
}

class _SubRedditPageState extends State<SubRedditPage> {
  bool isJoined = false;
  String currentSort = 'Hot';
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
      body: Column(
        children: [
          _subredditInfo(),
          const Divider(height: 1, thickness: 1),
          const SizedBox(height: 10),
          const Text('Posts'),
        ],
      ),
    );
  }

  Widget _sortingOptions() {
    return ListTile(
      title: Text(currentSort, style: TextStyle(color: Colors.white)),
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
                  ListTile(
                    title: const Text('Hot',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        currentSort = 'Hot';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('New',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        currentSort = 'New';
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Top',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      setState(() {
                        currentSort = 'Top';
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
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
