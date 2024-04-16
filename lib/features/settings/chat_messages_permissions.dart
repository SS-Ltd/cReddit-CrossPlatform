import 'package:flutter/material.dart';

/// A widget that represents the chat and messages permissions screen.
class ChatMessagesPermissions extends StatefulWidget {
  const ChatMessagesPermissions({super.key});

  @override
  State<ChatMessagesPermissions> createState() {
    return _ChatMessagesPermissionsState();
  }
}

class _ChatMessagesPermissionsState extends State<ChatMessagesPermissions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat and messages permissions',
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
