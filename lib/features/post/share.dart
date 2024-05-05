import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/post/choose_community.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/utils/utils_time.dart';

class Share extends StatefulWidget {
  const Share(
      {super.key,
      required this.post,
      required this.communityName,
      this.community});

  final PostModel? post;
  final String communityName;
  final Subreddit? community;

  @override
  State<StatefulWidget> createState() {
    return _ShareState();
  }
}

class _ShareState extends State<Share> {
  String chosenCommunity = "";
  Subreddit? details;

  Future getSubredditDetails(String subredditName) async {
    final subredditDetails =
        await context.read<NetworkService>().getSubredditDetails(subredditName);
    setState(() {
      details = subredditDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crosspost'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Post"),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              GestureDetector(
                child: Row(
                  children: [
                    (widget.communityName == "My Profile" ||
                            chosenCommunity == "My Profile")
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(context
                                .read<NetworkService>()
                                .user!
                                .profilePicture),
                          )
                        : (chosenCommunity != "")
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(details!.icon),
                              )
                            //not handled
                            : CircleAvatar(
                                backgroundImage: NetworkImage(context
                                    .read<NetworkService>()
                                    .user!
                                    .profilePicture),
                              ),
                    const SizedBox(width: 10),
                    Text(
                      (widget.communityName == "My Profile" ||
                              chosenCommunity == "My Profile")
                          ? "My Profile"
                          : (chosenCommunity != "")
                              ? "r/$chosenCommunity"
                              : "r/${widget.communityName}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Icon(Icons.keyboard_arrow_down_sharp),
                  ],
                ),
                onTap: () async {
                  final returnedData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const ChooseCommunity(
                        homePage: false,
                      ),
                    ),
                  );
                  setState(() {
                    if (returnedData != null) {
                      chosenCommunity = returnedData.toString();
                      if (chosenCommunity != "My Profile") {
                        getSubredditDetails(chosenCommunity);
                      }
                      print(chosenCommunity);
                    }
                  });
                },
              ),
              const Divider(thickness: 1),
              const SizedBox(height: 7),
              Text(
                widget.post!.title,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('r/${widget.post!.communityName}'),
                        const SizedBox(width: 10),
                        Text(
                          formatTimestamp(widget.post!.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text('u/${widget.post!.username}'),
                      ],
                    ),
                    Text(
                      widget.post!.title,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
