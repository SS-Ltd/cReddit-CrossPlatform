import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/features/home_page/choose_community.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/services/networkServices.dart';

class Share extends StatefulWidget {

  const Share({super.key, required this.post});

  final PostModel? post;

  @override
  State<StatefulWidget> createState() {
    return _ShareState();
  }
}

class _ShareState extends State<Share> {
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
                    const Icon(Icons.keyboard_arrow_down_sharp),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => const ChooseCommunity(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 1),
              Text(widget.post!.title),
            ],
          ),
        ),
      ),
    );
  }
}
