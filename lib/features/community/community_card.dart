import 'package:flutter/material.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

class CommunityCard extends StatefulWidget {
  final Community community;

  const CommunityCard({
    Key? key,
    required this.community,
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
      result = await context.read<NetworkService>().joinSubReddit(widget.community.name);
    } else {
      result =
          await context.read<NetworkService>().disJoinSubReddit(widget.community.name);
    }
    if (mounted && result) {
      isJoined.value = !isJoined.value;
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    isJoined = ValueNotifier<bool>(widget.community.isJoined);
  }

  @override
  void dispose() {
    isJoined.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Palette.communityCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: Colors.grey[850]!, width: 0.5),
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
                  backgroundImage: NetworkImage(widget.community.icon),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.community.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.community.members} members',
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
                                    color: Palette.blueJoinedColor, width: 2.0)
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
                                return Text(isJoined.value ? 'Joined' : 'Join');
                              }
                            },
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
              widget.community.description ?? '',
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
