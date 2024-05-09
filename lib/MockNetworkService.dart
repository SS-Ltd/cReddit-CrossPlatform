import 'package:reddit_clone/models/chat.dart';
import 'package:reddit_clone/models/chatmessage.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';

class MockNetworkService extends NetworkService {
  MockNetworkService() : super.instance();

  @override
  Future<List<Chat>> fetchChats() async {
    return [
      Chat(
        id: '1',
        name: 'Test Chat 1',
        lastSentMessage: Message(
            content: 'Hello',
            isRead: false,
            id: '',
            room: '',
            isDeleted: false,
            reactions: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        members: [],
        host: '',
        isDeleted: false,
      ),
    ];
  }

  @override
  Future<bool> blockUser(String username) async {
    return true;
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    // Mock implementation, maybe print something or just a simple return
    print('Marking chat as read: $chatId');
  }

  @override
  String getAccessToken() {
    return "mock-access-token";
  }

  @override
  Future<List<ChatMessages>?> fetchChatMessages(String chatId) async {
    return [
      ChatMessages(
        id: "1",
        user: "John Doe",
        room: "Test Room",
        content: "Hello there!",
        profilePicture: "https://example.com/image.png",
        isDeleted: false,
        reactions: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  getUser() {
    return UserModel(
        username: 'mockUser',
        displayName: '',
        email: '',
        profilePicture: '',
        followers: 0,
        cakeDay: DateTime.now(),
        isBlocked: false);
  }
}
