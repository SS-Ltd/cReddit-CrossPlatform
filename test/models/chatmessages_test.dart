import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/chatmessage.dart';

void main() {
  group('ChatMessages', () {
    test('fromJson should create a ChatMessages from JSON', () {
      var json = {
        '_id': '1',
        'username': 'User1',
        'room': 'Room1',
        'content': 'Test content',
        'profilePicture': 'https://example.com/image.jpg',
        'isDeleted': false,
        'reactions': [],
        'createdAt': '2022-01-01T00:00:00.000Z',
        'updatedAt': '2022-01-01T00:00:00.000Z',
      };

      var chatMessages = ChatMessages.fromJson(json);

      expect(chatMessages.id, equals('1'));
      expect(chatMessages.user, equals('User1'));
      expect(chatMessages.room, equals('Room1'));
      expect(chatMessages.content, equals('Test content'));
      expect(
          chatMessages.profilePicture, equals('https://example.com/image.jpg'));
      expect(chatMessages.isDeleted, equals(false));
      expect(chatMessages.reactions, equals([]));
      expect(chatMessages.createdAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(chatMessages.updatedAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
    });
  });
}
