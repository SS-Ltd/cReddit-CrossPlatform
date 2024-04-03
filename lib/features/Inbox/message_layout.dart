import 'package:flutter/material.dart';
import 'package:reddit_clone/features/Inbox/message_item.dart';

class MessageLayout extends StatelessWidget {
  final MessageItem message;
  final VoidCallback onTap;

  const MessageLayout({super.key, required this.message, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        message.isRead ? Icons.mail_outline : Icons.mail,
        color: message.isRead ? Colors.grey : Colors.blue,
      ),
      title: Text(
        message.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            '${message.senderUsername} • ${message.time}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_vert),
        onPressed: () {
          showMenu(
            context: context,
            position: const RelativeRect.fromLTRB(100.0, 200.0, 100.0, 100.0),
            items: [
              PopupMenuItem<String>(
                value: 'block',
                child: ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Block account'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      ),
      onTap: onTap,
    );
  }
}
