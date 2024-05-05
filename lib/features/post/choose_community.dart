import 'package:flutter/material.dart';
import 'package:reddit_clone/features/post/share.dart';
import 'package:reddit_clone/models/joined_communities.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

class ChooseCommunity extends StatefulWidget {
  const ChooseCommunity({super.key, required this.homePage, this.post});

  final bool homePage;
  final PostModel? post;

  @override
  State<ChooseCommunity> createState() {
    return _ChooseCommunityState();
  }
}

class _ChooseCommunityState extends State<ChooseCommunity> {
  List<JoinedCommunitites>? joinedCommunities = [];

  @override
  void initState() {
    super.initState();
    fetcheddata();
  }

  /// Fetches the data for the joined communities.
  Future<void> fetcheddata() async {
    joinedCommunities =
        await Provider.of<NetworkService>(context, listen: false)
            .joinedcommunitites();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Set<Subreddit>? recentlyvisited =
        context.read<NetworkService>().user!.recentlyVisited;
    List<Subreddit>? listRecentlyVisited = recentlyvisited.toList();
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Choose a Community'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Profile"),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          context.read<NetworkService>().user!.profilePicture),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "My Profile",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  widget.homePage
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => Share(
                              post: widget.post,
                              communityName: "My Profile",
                            ),
                          ),
                        )
                      : Navigator.of(context).pop("My Profile");
                },
              ),
              const SizedBox(
                height: 20,
              ),
              if (listRecentlyVisited.isNotEmpty)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Recently Visited"),
                  ],
                ),
              if (listRecentlyVisited.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: context
                        .read<NetworkService>()
                        .user!
                        .recentlyVisited
                        .length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              widget.homePage
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => Share(
                                          post: widget.post,
                                          communityName:
                                              listRecentlyVisited[index].name,
                                        ),
                                      ),
                                    )
                                  : Navigator.of(context).pop(
                                      listRecentlyVisited[index].name,
                                    );
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(listRecentlyVisited[index].icon),
                            ),
                            title: Text('r/${listRecentlyVisited[index].name}'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              if (joinedCommunities != null)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Joined"),
                  ],
                ),
              if (joinedCommunities != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: joinedCommunities!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              widget.homePage
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => Share(
                                          post: widget.post,
                                          communityName:
                                              joinedCommunities![index].name,
                                        ),
                                      ),
                                    )
                                  : Navigator.of(context).pop(
                                      joinedCommunities![index].name,
                                    );
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  joinedCommunities![index].profilePicture),
                            ),
                            title: Text('r/${joinedCommunities![index].name}'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
