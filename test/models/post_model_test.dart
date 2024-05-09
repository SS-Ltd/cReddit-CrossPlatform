import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/post_model.dart';

void main() {
  group('PostModel', () {
    test('fromJson should create a PostModel from JSON', () {
      var json = {
        '_id': '1',
        'type': 'Test Type',
        'username': 'User1',
        'communityName': 'Community1',
        'title': 'Test Title',
        'content': 'Test Content',
        'pollOptions': [
          {'text': 'Option1', 'isVoted': false, 'votes': 0},
          {'text': 'Option2', 'isVoted': true, 'votes': 1},
        ],
        'expirationDate': '2022-01-01T00:00:00.000Z',
        'netVote': 1,
        'isSpoiler': false,
        'isLocked': false,
        'isApproved': true,
        'isEdited': false,
        'createdAt': '2022-01-01T00:00:00.000Z',
        'updatedAt': '2022-01-01T00:00:00.000Z',
        'profilePicture': 'https://example.com/image.jpg',
        'commentCount': 1,
        'isDeletedUser': false,
        'isUpvoted': true,
        'isDownvoted': false,
        'isSaved': true,
        'isHidden': false,
        'isJoined': true,
        'isModerator': false,
        'isBlocked': false,
        'isNSFW': false,
      };

      var postModel = PostModel.fromJson(json);

      expect(postModel.postId, equals('1'));
      expect(postModel.type, equals('Test Type'));
      expect(postModel.username, equals('User1'));
      expect(postModel.communityName, equals('Community1'));
      expect(postModel.title, equals('Test Title'));
      expect(postModel.content, equals('Test Content'));
      expect(postModel.pollOptions![0].option, equals('Option1'));
      expect(postModel.pollOptions![0].isVoted, equals(false));
      expect(postModel.pollOptions![0].votes, equals(0));
      expect(postModel.pollOptions![1].option, equals('Option2'));
      expect(postModel.pollOptions![1].isVoted, equals(true));
      expect(postModel.pollOptions![1].votes, equals(1));
      expect(postModel.expirationDate,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(postModel.netVote, equals(1));
      expect(postModel.isSpoiler, equals(false));
      expect(postModel.isLocked, equals(false));
      expect(postModel.isApproved, equals(true));
      expect(postModel.isEdited, equals(false));
      expect(postModel.createdAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(postModel.updatedAt,
          equals(DateTime.parse('2022-01-01T00:00:00.000Z')));
      expect(postModel.profilePicture, equals('https://example.com/image.jpg'));
      expect(postModel.commentCount, equals(1));
      expect(postModel.isDeletedUser, equals(false));
      expect(postModel.isUpvoted, equals(true));
      expect(postModel.isDownvoted, equals(false));
      expect(postModel.isSaved, equals(true));
      expect(postModel.isHidden, equals(false));
      expect(postModel.isJoined, equals(true));
      expect(postModel.isModerator, equals(false));
      expect(postModel.isBlocked, equals(false));
      expect(postModel.isNSFW, equals(false));
    });
  });

  group('PollsOption', () {
    test('fromJson should create a PollsOption from JSON', () {
      var json = {
        'text': 'Option1',
        'isVoted': false,
        'votes': 0,
      };

      var pollsOption = PollsOption.fromJson(json);

      expect(pollsOption.option, equals('Option1'));
      expect(pollsOption.isVoted, equals(false));
      expect(pollsOption.votes, equals(0));
    });
  });
}
