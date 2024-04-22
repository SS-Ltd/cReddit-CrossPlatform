import 'package:flutter/material.dart';
import 'package:reddit_clone/features/chat/chat_screen.dart';
import 'package:reddit_clone/new_page.dart';
import 'package:reddit_clone/theme/palette.dart';

class ChatListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatInfo; // List of chat information
  final List<Map<String, dynamic>> channelInfo; // List of channels information

  ChatListScreen({required this.chatInfo, required this.channelInfo});

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: const Text('Filter Chats'),
              ),
              const Divider(),
              ListTile(
                title: const Text('Chat Channels'),
                trailing: Icon(Icons.check_box_outline_blank),
                onTap: () => {},
              ),
              ListTile(
                title: const Text('Group Chats'),
                trailing: Icon(Icons.check_box_outline_blank),
                onTap: () => {},
              ),
              ListTile(
                title: const Text('Direct Chats'),
                trailing: Icon(Icons.check_box_outline_blank),
                onTap: () => {},
              ),
              ListTile(
                title: const Text('Done'),
                onTap: () => Navigator.pop(context),
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
            icon: Icon(Icons.message),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewPage()), // Assume you have a NewMessageScreen
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showFilterModal(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Logic to open user profiles or settings
            },
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
                const Text('Discover Channels'),
                ElevatedButton(
                  onPressed: () {
                    // Logic to view all channels
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: channelInfo.length,
              itemBuilder: (context, index) {
                final channel = channelInfo[index];
                return Container(
                  width: 250,
                  child: Card(
                    color: Palette.settingsHeading,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(channel['profilePic']),
                      ),
                      title: Text(channel['name'],
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(channel['description'],
                          style: TextStyle(color: Colors.grey[400])),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Threads'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Logic to navigate to Threads page
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chatInfo.length,
              itemBuilder: (context, index) {
                final chat = chatInfo[index];
                return Card(
                  color: Palette.settingsHeading,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat['profilePic']),
                    ),
                    title: Text(chat['name'],
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(chat['lastMessage'],
                        style: TextStyle(color: Colors.grey[400])),
                    trailing: Text(chat['time'],
                        style: TextStyle(color: Colors.grey[400])),
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
