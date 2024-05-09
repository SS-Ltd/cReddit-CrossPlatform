import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/chat.dart';

void main() {
  group('Chat', () {
    test('fromJson should create a Chat from JSON', () {
      var json = {
        '_id': '1',
        'name': 'Test Chat',
        'members': ['User1', 'User2'],
        'host': 'User1',
        'isDeleted': false,
        'createdAt': '2022-01-01T00:00:00.000Z',
        'updatedAt': '2022-01-01T00:00:00.000Z',
        'lastSentMessage': null,
      };

      var chat = Chat.fromJson(json);

      expect(chat.id, equals('1'));
      expect(chat.name, equals('Test Chat'));
      expect(chat.members, equals(['User1', 'User2']));
      expect(chat.host, equals('User1'));
      expect(chat.isDeleted, equals(false));
      expect(
          chat.createdAt, equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(
          chat.updatedAt, equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(chat.lastSentMessage, equals(null));
    });
  });

  group('Message', () {
    test('fromJson should create a Message from JSON', () {
      var json = {
        '_id': '1',
        'user': 'User1',
        'room': 'Room1',
        'content': 'Test content',
        'isDeleted': false,
        'isRead': false,
        'reactions': [],
        'createdAt': '2022-01-01T00:00:00.000Z',
        'updatedAt': '2022-01-01T00:00:00.000Z',
      };

      var message = Message.fromJson(json);

      expect(message.id, equals('1'));
      expect(message.user, equals('User1'));
      expect(message.room, equals('Room1'));
      expect(message.content, equals('Test content'));
      expect(message.isDeleted, equals(false));
      expect(message.isRead, equals(false));
      expect(message.reactions, equals([]));
      expect(message.createdAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(message.updatedAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
    });
  });
}
