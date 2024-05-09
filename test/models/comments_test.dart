import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/comments.dart';

void main() {
  group('Comments', () {
    test('fromJson creates a correct Comments object', () {
      final json = {
        'profilePicture': 'test_profile_picture',
        'username': 'test_username',
        'isImage': true,
        'netVote': 10,
        'content': 'test_content',
        'createdAt': 'test_createdAt',
        '_id': 'test_id',
        'isUpvoted': true,
        'isDownvoted': false,
        'isSaved': true,
        'communityName': 'test_communityName',
        'postID': 'test_postID',
        'title': 'test_title',
        'isApproved': true,
      };

      final expectedComments = Comments(
        profilePicture: 'test_profile_picture',
        username: 'test_username',
        isImage: true,
        netVote: 10,
        content: 'test_content',
        createdAt: 'test_createdAt',
        commentId: 'test_id',
        isUpvoted: true,
        isDownvoted: false,
        isSaved: true,
        communityName: 'test_communityName',
        postId: 'test_postID',
        title: 'test_title',
        isApproved: true,
      );

      final comments = Comments.fromJson(json);

      expect(comments, expectedComments);
    });
    test('toJson creates a correct JSON object', () {
      final comments = Comments(
        profilePicture: 'test_profile_picture',
        username: 'test_username',
        isImage: true,
        netVote: 10,
        content: 'test_content',
        createdAt: 'test_createdAt',
        commentId: 'test_id',
        isUpvoted: true,
        isDownvoted: false,
        isSaved: true,
        communityName: 'test_communityName',
        postId: 'test_postID',
        title: 'test_title',
        isApproved: true,
      );

      final expectedJson = {
        'profilePicture': 'test_profile_picture',
        'username': 'test_username',
        'isImage': true,
        'netVote': 10,
        'content': 'test_content',
        'createdAt': 'test_createdAt',
        '_id': 'test_id',
        'isUpvoted': true,
        'isDownvoted': false,
        'isSaved': true,
        'communityName': 'test_communityName',
        'postID': 'test_postID',
        'title': 'test_title',
        'isApproved': true,
      };

      expect(comments.toJson(), expectedJson);
    });

    
  });
}
