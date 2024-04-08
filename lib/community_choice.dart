import 'dart:js';
import 'package:reddit_clone/models/joined_communities.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/Network.dart';
import 'package:provider/provider.dart';

class CommunityChoice extends StatefulWidget {
  const CommunityChoice({
    super.key,
    required this.chosenCommunity,
  });

  final String chosenCommunity;

  @override
  State<CommunityChoice> createState() {
    return _CommunityChoiceState();
  }
}

class _CommunityChoiceState extends State<CommunityChoice> {

  List<JoinedCommunitites>? joinedCommunities = [];


  @override
  void initState() {
    super.initState();
    fetcheddata();
  }

  Future<void> fetcheddata() async {
    joinedCommunities =
        await Provider.of<NetworkService>(context, listen: false)
            .joinedcommunitites();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Post to'),
        ),
        body: joinedCommunities == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: joinedCommunities!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(joinedCommunities![index].name),
                    onTap: () {
                      Navigator.pop(context, joinedCommunities![index].name);
                    },
                  );
                },
              ),
      ),
    );
  }
}
