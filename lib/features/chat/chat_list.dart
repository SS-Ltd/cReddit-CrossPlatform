import 'package:flutter/material.dart';
import 'package:reddit_clone/features/chat/chat_screen.dart';
import 'package:reddit_clone/new_page.dart';
import 'package:reddit_clone/theme/palette.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatInfo; // List of chat information
  final List<Map<String, dynamic>> channelInfo; // List of channels information

  const ChatListScreen(
      {super.key, required this.chatInfo, required this.channelInfo});

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              const ListTile(
                title: Text('Filter Chats'),
              ),
              const Divider(),
              CheckboxListTile(
                title: const Text('Chat Channels'),
                value: true,
                onChanged: (bool? newValue) {},
              ),
              CheckboxListTile(
                title: const Text('Group Chats'),
                value: false,
                onChanged: (bool? newValue) {},
              ),
              CheckboxListTile(
                title: const Text('Direct Chats'),
                value: false,
                onChanged: (bool? newValue) {},
              ),
              Center(
                child: Container(
                  width: 400,
                  child: ElevatedButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                      MaterialPageRoute(builder: (context) => const NewPage()),
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: channelInfo.length,
              itemBuilder: (context, index) {
                final channel = channelInfo[index];
                return Container(
                  width: 360,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: .4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(channel['profilePic']),
                    ),
                    title: Text(channel['name'],
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(channel['description'],
                        style: TextStyle(color: Colors.grey[400])),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.repeat,
                color: Colors.white), // curved arrow icon
            title: const Text('Threads', style: TextStyle(color: Colors.white)),
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
                      backgroundImage: NetworkImage(chat['profilePic']),
                    ),
                    title: Text(chat['name'],
                        style: TextStyle(
                            color: isUnread ? Colors.white : Colors.grey[400],
                            fontWeight: isUnread
                                ? FontWeight.bold
                                : FontWeight.normal)),
                    subtitle: Text(chat['lastMessage'],
                        style: TextStyle(
                            color: isUnread ? Colors.white : Colors.grey[400])),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        const SizedBox(width: 5),
                        Text(chat['time'],
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatScreen(recipientId: chat['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
