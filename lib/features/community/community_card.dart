import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

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

  @override
  void initState() {
    super.initState();
    isJoined = ValueNotifier<bool>(widget.isJoined);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 12, 12, 12),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20), // Adjust as needed
      side: BorderSide(color: Colors.grey[800]!, width:0.75), // Adjust as needed
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
                    return ElevatedButton(
                      onPressed: () {
                        isJoined.value = !isJoined.value;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            value ? Palette.transparent : Palette.blueColor,
                        foregroundColor:
                            value ? Palette.blueColor : Palette.whiteColor,
                        side: value
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
