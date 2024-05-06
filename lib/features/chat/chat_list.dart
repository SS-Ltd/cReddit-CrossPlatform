import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:reddit_clone/features/chat/chat_screen.dart';
import 'package:reddit_clone/features/chat/view_all_channels.dart';
import 'package:reddit_clone/models/chat.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/utils/utils_time.dart';

class ChatListScreen extends StatefulWidget {
  final List<Map<String, dynamic>> channelInfo; // List of channels information
  const ChatListScreen({super.key, required this.channelInfo});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<Chat> chats = [];
  Future<void> fetchChats() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final posts = await networkService.fetchChats();
    if (posts == null) return;
    if (mounted) {
      setState(() {
        chats = posts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Discover Channels',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewAllChannels(channels: widget.channelInfo),
                        ),
                      );
                    },
                    child:
                        const Text('View All', style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.channelInfo.length,
                itemBuilder: (context, index) {
                  final channel = widget.channelInfo[index];
                  return Container(
                    width: MediaQuery.of(context).size.width - 15,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 97, 96, 96),
                          width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(channel['profilePic']),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                channel['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        channel['description'],
                                        style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage('https://picsum.photos/200'),
                                    ),
                                    const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage('https://picsum.photos/201'),
                                    ),
                                    const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage('https://picsum.photos/202'),
                                    ),
                                    const SizedBox(width: 10),
                                    const SpinKitThreeBounce(color: Colors.white, size: 10.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.repeat,
                  color: Colors.white), // curved arrow icon
              title:
                  const Text('Threads', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward, color: Colors.white),
              onTap: () {},
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  bool isUnread = false; //change when mahmoud finishes
                  final random = Random();
                  final svgCode =
                      RandomAvatarString(random.nextInt(1000000).toString());
                  return Card(
                    color: Palette.settingsHeading,
                    child: ListTile(
                      leading: SvgPicture.string(
                        svgCode,
                        width: 56, // Adjust as needed
                        height: 56, // Adjust as needed
                        fit: BoxFit.cover,
                      ),
                      title: Text(chat.name,
                          style: TextStyle(
                              color: isUnread ? Colors.white : Colors.grey[400],
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                      subtitle: Text(chat.lastSentMessage?.content ?? '',
                          style: TextStyle(
                              color:
                                  isUnread ? Colors.white : Colors.grey[400])),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Text(formatTimestamp(chat.updatedAt as DateTime),
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 12)),
                          const SizedBox(height: 15),
                          if (isUnread)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                            ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      chatId: chat.id,
                                      usernameOrGroupName: chat.name,
                                    )));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
