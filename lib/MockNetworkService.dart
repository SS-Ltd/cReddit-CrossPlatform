import 'package:reddit_clone/models/chat.dart';
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
}
