import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/comments.dart';

void main() {
  group('Comments', () {
    test('fromJson should create a Comments from JSON', () {
      var json = {
        'profilePicture': 'https://example.com/image.jpg',
        'username': 'User1',
        'isImage': false,
        'netVote': 1,
        'content': 'Test content',
        'createdAt': '2022-01-01T00:00:00.000Z',
        '_id': '1',
        'isUpvoted': true,
        'isDownvoted': false,
        'isSaved': true,
        'communityName': 'Community1',
        'postID': 'Post1',
        'title': 'Test Title',
        'isApproved': true,
      };

      var comments = Comments.fromJson(json);

      expect(comments.profilePicture, equals('https://example.com/image.jpg'));
      expect(comments.username, equals('User1'));
      expect(comments.isImage, equals(false));
      expect(comments.netVote, equals(1));
      expect(comments.content, equals('Test content'));
      expect(comments.createdAt, equals('2022-01-01T00:00:00.000Z'));
      expect(comments.commentId, equals('1'));
      expect(comments.isUpvoted, equals(true));
      expect(comments.isDownvoted, equals(false));
      expect(comments.isSaved, equals(true));
      expect(comments.communityName, equals('Community1'));
      expect(comments.postId, equals('Post1'));
      expect(comments.title, equals('Test Title'));
      expect(comments.isApproved, equals(true));
    });
  });
}
