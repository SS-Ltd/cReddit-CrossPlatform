import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

class CommunityCard extends StatefulWidget {
  final String title;
  final int members;
  final String description;
  final String avatarUrl;

  const CommunityCard({
    Key? key,
    required this.title,
    required this.members,
    required this.description,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  CommunityCardState createState() => CommunityCardState();
}

class CommunityCardState extends State<CommunityCard> {
  final ValueNotifier<bool> isJoined = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 12, 12),
      shape: Border.all(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.avatarUrl),
                  radius: 25,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.members} members',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: isJoined,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: () {
                        isJoined.value = !isJoined.value;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            value ? Palette.transparent : Palette.blueColor,
                        foregroundColor:
                            value ? Palette.blueColor : Palette.whiteColor,
                        side: isJoined.value
                            ? const BorderSide(
                                color: Palette.blueColor, width: 2.0)
                            : BorderSide.none,
                      ),
                      child: Text(value ? 'Joined' : 'Join'),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
