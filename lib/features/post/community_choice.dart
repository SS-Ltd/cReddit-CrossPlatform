import 'package:reddit_clone/models/joined_communities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

/// A widget that allows the user to choose a community for posting.
class CommunityChoice extends StatefulWidget {
  /// The chosen community for posting.
  String chosenCommunity;

  /// Constructs a [CommunityChoice] widget.
  ///
  /// The [chosenCommunity] parameter is required.
  CommunityChoice({
    super.key,
    required this.chosenCommunity,
  });

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

  /// Fetches the data for the joined communities.
  Future<void> fetcheddata() async {
    joinedCommunities =
        await Provider.of<NetworkService>(context, listen: false)
            .joinedcommunitites();
    setState(() {});
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
                child: Text('Go to communities '),
              )
            : ListView.builder(
                itemCount: joinedCommunities!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          joinedCommunities![index].profilePicture),
                    ),
                    title: Text(joinedCommunities![index].name),
                    subtitle: Text(
                        '${joinedCommunities![index].members.toString()} members'),
                    onTap: () {
                      Navigator.of(context).pop(joinedCommunities![index].name);
                    },
                  );
                },
              ),
      ),
    );
  }
}
