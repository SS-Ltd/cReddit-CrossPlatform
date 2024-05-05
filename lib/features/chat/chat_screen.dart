import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/chatmessage.dart';
import 'package:reddit_clone/models/chatmessages.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/utils/utils_time.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String chatId;

  const ChatScreen(
      {super.key, required this.recipientId, required this.chatId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [];
  final messageController = TextEditingController();
  bool isFirstMessage = true; // Assuming this is to check if it's a new chat
  List<ChatMessages> chatMessages = [];
  late IO.Socket socket;
  Future<void> fetchChatMessages() async {
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final messages = await networkService.fetchChatMessages(widget.chatId);
    if (messages == null) return;
    setState(() {
      chatMessages = messages;
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  @override
  void initState() {
    super.initState();
    messages.add(ChatMessage(
        senderId: 'user1',
        recipientId: 'user2',
        message: 'Hello!',
        timestamp: DateTime.now()));
    messages.add(ChatMessage(
        senderId: 'user1',
        recipientId: 'user2',
        message: 'Hello!!!',
        timestamp: DateTime.now()));
    messages.add(ChatMessage(
        senderId: 'user2',
        recipientId: 'user1',
        message: 'Hi there!',
        timestamp: DateTime.now()));
    messages.add(ChatMessage(
        senderId: 'user1',
        recipientId: 'user2',
        message: 'Hello!!!!!!!',
        timestamp: DateTime.now()));
    final networkService = Provider.of<NetworkService>(context, listen: false);
    final accessToken = networkService.getAccessToken();
    socket = IO.io('http://192.168.1.10:3000', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'extraHeaders': {
        'cookie': 'accessToken=$accessToken',
      },
    });
    fetchChatMessages();
    connectAndListen();
  }

  void connectAndListen() {
    UserModel user = context.read<NetworkService>().getUser();
    socket.connect();
    socket.on('connect', (data) => print('Connected'));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Username', // This should be the recipient's username
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.more_vert),
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => const NewPage()));
            //   },
            // ),
          ],
        ),
      ),
      body: Column(
        children: [
          isFirstMessage ? introSection() : Container(),
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final chatMessage = chatMessages[index];
                bool showUserInfo = true; // Default to showing user info
                // Check if the current message is from the same sender as the previous one
                if (index > 0 &&
                    chatMessages[index - 1].user == chatMessage.user) {
                  showUserInfo =
                      false; // Do not show user info if the sender is the same
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showUserInfo)
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage:
                                NetworkImage("https://i.imgur.com/BoN9kdC.png"),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(chatMessage.user ?? ''),
                              Text(formatTimestamp(chatMessage.createdAt)),
                            ],
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0,
                          bottom: 8.0,
                          left: 50.0), // Add left padding to the message
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

  Widget introSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
              "https://i.imgur.com/BoN9kdC.png"), // Recipient's large profile picture
        ),
        const SizedBox(height: 10),
        const Text(
          'Username', // Recipient's username
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text('Redditor for 7m 25d'),
        TextButton(
          onPressed: () {}, // Navigate to recipient's profile
          child: const Text('View Profile'),
        ),
      ],
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
              // final message = ChatMessage(
              //   senderId: 'currentUserId', // Replace with the current user's ID
              //   recipientId: widget.recipientId,
              //   message: messageController.text,
              //   timestamp: DateTime.now(),
              // );
              // setState(() {
              //   messages.add(message);
              //   isFirstMessage =
              //       false; // After the first message, remove the intro section
              // });
              // messageController.clear();
              UserModel user = context.read<NetworkService>().getUser();
              socket.emit('chatMessage', {
                'username': user.username,
                'message': messageController.text,
                'roomId': widget.chatId,
                //MAHMOUD ENTA 3AYZ HAGA ZY KDA?
              });
            },
          ),
        ],
      ),
    );
  }
}
