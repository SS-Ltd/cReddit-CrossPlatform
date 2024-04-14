import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

class CommunityCard extends StatefulWidget {
  final String name;
  final int members;
  final String description;
  final String icon;
  final bool isJoined;

  const CommunityCard({
    Key? key,
    required this.name,
    required this.members,
    required this.description,
    required this.icon,
    required this.isJoined,
  }) : super(key: key);

  @override
  CommunityCardState createState() => CommunityCardState();
}

class CommunityCardState extends State<CommunityCard> {
  late final ValueNotifier<bool> isJoined;
  Future<bool>? _future;

  Future<bool> joinOrDisjoinSubreddit() async {
    bool result;
    if (!isJoined.value) {
      result = await context.read<NetworkService>().joinSubReddit(widget.name);
    } else {
      result =
          await context.read<NetworkService>().disJoinSubReddit(widget.name);
    }
    if (mounted && result) {
      isJoined.value = !isJoined.value;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    isJoined = ValueNotifier<bool>(widget.isJoined);
  }

  @override
  void dispose() {
    isJoined.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 12, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Adjust as needed
        side: BorderSide(
            color: Colors.grey[800]!, width: 0.75), // Adjust as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.icon),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.members} members',
                        style: const TextStyle(
                            fontSize: 11, color: Palette.greyColor),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isJoined,
                  builder: (context, value, child) {
                    return SizedBox(
                      height: 33,
                      child: ButtonTheme(
                        minWidth: 0,
                        child: Semantics(
                          label: "join or disjoin subreddit",
                          identifier: "join or disjoin subreddit",
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _future = joinOrDisjoinSubreddit();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: value
                                  ? Palette.transparent
                                  : Palette.blueJoinColor,
                              foregroundColor: value
                                  ? Palette.blueJoinedColor
                                  : Palette.whiteColor,
                              side: value
                                  ? const BorderSide(
                                      color: Palette.blueJoinedColor,
                                      width: 2.0)
                                  : BorderSide.none,
                              padding: EdgeInsets.zero, // Add this line
                            ),
                            child: FutureBuilder<bool>(
                              future: _future,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Palette.blueJoinedColor),
                                    ),
                                  );
                                } else {
                                  return Text(
                                      isJoined.value ? 'Joined' : 'Join');
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 11, color: Palette.greyColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
