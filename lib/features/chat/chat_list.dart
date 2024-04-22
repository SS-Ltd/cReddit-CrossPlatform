import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reddit_clone/features/chat/chat_screen.dart';
import 'package:reddit_clone/new_page.dart';
import 'package:reddit_clone/theme/palette.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatInfo; // List of chat information
  final List<Map<String, dynamic>> channelInfo; // List of channels information

  const ChatListScreen(
      {super.key, required this.chatInfo, required this.channelInfo});

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
                              builder: (context) => const NewPage()));
                    },
                    child:
                        const Text('View All', style: TextStyle(fontSize: 15)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100, // Increased height for better layout
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: channelInfo.length,
                itemBuilder: (context, index) {
                  final channel = channelInfo[index];
                  return Container(
                    width: 350, // Adjusted width
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
                              Text(channel['name'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              Row(
                                children: [
                                  Text(channel['description'],
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 12)),
                                  const SizedBox(width: 10),
                                  const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                          'https://picsum.photos/200')),
                                  const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                          'https://picsum.photos/201')),
                                  const CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                          'https://picsum.photos/202')),
                                  const SizedBox(width: 10),
                                  const SpinKitThreeBounce(
                                      color: Colors.white, size: 10.0),
                                ],
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
                itemCount: chatInfo.length,
                itemBuilder: (context, index) {
                  final chat = chatInfo[index];
                  bool isUnread = chat['unread'];
                  return Card(
                    color: Palette.settingsHeading,
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(chat['profilePic'])),
                      title: Text(chat['name'],
                          style: TextStyle(
                              color: isUnread ? Colors.white : Colors.grey[400],
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                      subtitle: Text(chat['lastMessage'],
                          style: TextStyle(
                              color:
                                  isUnread ? Colors.white : Colors.grey[400])),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          const SizedBox(height: 5),
                          Text(chat['time'],
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
                                builder: (context) =>
                                    ChatScreen(recipientId: chat['id'])));
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
