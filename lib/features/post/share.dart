import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/features/post/choose_community.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/utils/utils_time.dart';

class Share extends StatefulWidget {
  const Share({
    super.key,
    required this.post,
    required this.communityName,
  });

  final PostModel? post;
  final String communityName;

  @override
  State<StatefulWidget> createState() {
    return _ShareState();
  }
}

class _ShareState extends State<Share> {
  String chosenCommunity = "";
  Subreddit? details;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    getSubredditDetails(widget.communityName);
    _titleController = TextEditingController(text: widget.post!.title);
  }

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
              onPressed: () async {
                bool posted = await context
                    .read<NetworkService>()
                    .createCrossPost(
                        widget.post!.postId, _titleController.text);
                if (posted) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomNavigationBar(
                                isProfile: false,
                              )),
                      (route) => false);
                }
              },
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
                            backgroundImage: AssetImage(context
                                .read<NetworkService>()
                                .user!
                                .profilePicture),
                          )
                        : (chosenCommunity != "")
                            ? CircleAvatar(
                                backgroundImage: AssetImage(details!.icon),
                              )
                            //not handled
                            : CircleAvatar(
                                backgroundImage: AssetImage(details!.icon),
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
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(fontSize: 30),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  print(_titleController.text);
                },
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
