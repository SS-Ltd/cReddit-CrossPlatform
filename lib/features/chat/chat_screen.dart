import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/chatmessage.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/utils/utils_time.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String usernameOrGroupName;

  const ChatScreen(
      {super.key, required this.chatId, required this.usernameOrGroupName});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final messageController = TextEditingController();
  List<ChatMessages> chatMessages = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    initializeSocket();
    fetchChatMessages();
    markChatAsRead();
  }

  void markChatAsRead() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    await networkService.markChatAsRead(widget.chatId);
  }

  void initializeSocket() {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final accessToken = networkService.getAccessToken();
    socket = IO.io('https://api.creddit.tech/', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'extraHeaders': {'cookie': 'accessToken=$accessToken'},
    });
    connectAndListen();
  }

  Future<void> fetchChatMessages() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final messages = await networkService.fetchChatMessages(widget.chatId);
    if (messages != null) {
      setState(() {
        chatMessages = messages;
      });
    }
  }

  void connectAndListen() {
    UserModel user = context.read<NetworkService>().getUser();
    socket.connect();
    socket.on('connect', (data) => print('Connected'));
    socket.on('connect_error', (err) => print('Connect error: $err'));
    socket.on(
        'connect_timeout', (timeout) => print('Connect timeout: $timeout'));
    socket.on('error', (err) => print('Error: $err'));
    socket.on('disconnect', (reason) => print('Disconnected: $reason'));
    socket.on(
        'reconnect', (attemptNumber) => print('Reconnected: $attemptNumber'));
    socket.on('reconnect_attempt',
        (attemptNumber) => print('Reconnect attempt: $attemptNumber'));
    socket.on('reconnecting',
        (attemptNumber) => print('Reconnecting: $attemptNumber'));
    socket.on('reconnect_error', (err) => print('Reconnect error: $err'));

    socket
        .emit('joinRoom', {'rooms': widget.chatId, 'username': user.username});
    socket.on('newMessage', (data) {
      if (mounted) {
        print('New message: $data');
        //Add the new message to the chatMessages list
        setState(() {
          chatMessages.add(ChatMessages(
            id: 'some-id', // Replace with actual id
            user: data['username'],
            room: 'some-room', // Replace with actual room
            content: data['message'],
            profilePicture: data['profilePicture'],
            isDeleted: false, // Replace with actual isDeleted
            reactions: [], // Replace with actual reactions
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
        });
      }
    });
    socket.on('error', (data) => print('Error: $data'));
    socket.on('onlineUser', (data) => print('Online user: $data'));
    socket.on('joinedRoom', (data) => print('Joined room: $data'));
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usernameOrGroupName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = chatMessages[index];
                bool showUserInfo = index == 0 ||
                    chatMessages[index - 1].user != chatMessage.user;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showUserInfo && chatMessage.user != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            if (chatMessage.user != null)
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    chatMessage.profilePicture ?? ''),
                              ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(chatMessage.user!)),
                            Text(formatTimestamp(chatMessage.createdAt),
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0),
                      child: Text(chatMessage.content),
                    ),
                  ],
                );
              },
            ),
          ),
          messageInputField(),
        ],
      ),
    );
  }

  Widget messageInputField() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              // Logic to open camera
            },
          ),
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message',
                border: InputBorder.none,
              ),
              maxLines: null, // Allows input field to expand as text wraps
            ),
          ),
          IconButton(
            icon: const Icon(Icons.gif),
            onPressed: () {
              // Logic to send GIF
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            onPressed: () {
              // Logic to insert emoji
            },
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: () {
              UserModel user = context.read<NetworkService>().getUser();
              socket.emit('chatMessage', {
                'username': user.username,
                'message': messageController.text,
                'roomId': widget.chatId,
              });
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
