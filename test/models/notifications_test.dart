import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/notification.dart';

void main() {
  group('NotificationModel', () {
    test('fromJson should create a NotificationModel from JSON', () {
      var json = {
        '_id': '1',
        'user': 'User1',
        'notificationFrom': 'User2',
        'type': 'Test Type',
        'resourceId': 'Resource1',
        'title': 'Test Title',
        'content': 'Test Content',
        'isRead': false,
        'createdAt': '2022-01-01T00:00:00.000Z',
        'updatedAt': '2022-01-01T00:00:00.000Z',
        'profilePicture': 'https://example.com/image.jpg',
      };

      var notificationModel = NotificationModel.fromJson(json);

      expect(notificationModel.id, equals('1'));
      expect(notificationModel.user, equals('User1'));
      expect(notificationModel.notificationFrom, equals('User2'));
      expect(notificationModel.type, equals('Test Type'));
      expect(notificationModel.resourceId, equals('Resource1'));
      expect(notificationModel.title, equals('Test Title'));
      expect(notificationModel.content, equals('Test Content'));
      expect(notificationModel.isRead, equals(false));
      expect(notificationModel.createdAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(notificationModel.updatedAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(notificationModel.profilePic,
          equals('https://example.com/image.jpg'));
    });
  });
}
