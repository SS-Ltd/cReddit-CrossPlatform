import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/messages.dart';

void main() {
  group('Messages', () {
    test('fromJson should create a Messages from JSON', () {
      var json = {
        '_id': '1',
        'from': 'User1',
        'to': 'User2',
        'subject': 'Test Subject',
        'text': 'Test Text',
        'isRead': false,
        'isDeleted': true,
        'createdAt': '2022-01-01T00:00:00.000Z',
      };

      var messages = Messages.fromJson(json);

      expect(messages.id, equals('1'));
      expect(messages.from, equals('User1'));
      expect(messages.to, equals('User2'));
      expect(messages.subject, equals('Test Subject'));
      expect(messages.text, equals('Test Text'));
      expect(messages.isRead, equals(false));
      expect(messages.isDeleted, equals(true));
      expect(messages.createdAt, equals('2022-01-01T00:00:00.000Z'));
    });
  });
}
