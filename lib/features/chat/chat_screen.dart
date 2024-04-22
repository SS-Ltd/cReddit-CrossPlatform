import 'package:flutter/material.dart';
import 'package:reddit_clone/models/chatmessages.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;

  ChatScreen({required this.recipientId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages =
      []; // This will be replaced with your actual messages
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.message),
                  subtitle: Text(
                      'Sent by ${message.senderId} at ${message.timestamp}'),
                );
              },
            ),
          ),
          TextField(
            controller: messageController,
            decoration: InputDecoration(
              labelText: 'Type a message',
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  final message = ChatMessage(
                    senderId:
                        'currentUserId', // Replace with the current user's ID
                    recipientId: widget.recipientId,
                    message: messageController.text,
                    timestamp: DateTime.now(),
                  );
                  setState(() {
                    messages.add(message);
                  });
                  messageController.clear();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
