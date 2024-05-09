import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/search.dart';

void main() {
  test('SearchComments fromJson', () {
    final json = {
      '_id': '123',
      'postID': '456',
      'postTitle': 'Test Post',
      'postUsername': 'Test User',
      'postVotes': 10,
      'postPicture': 'Test Picture',
      'postCreatedAt': 'Test Date',
      'isPostNsfw': false,
      'isPostSpoiler': false,
      'username': 'Test User',
      'communityName': 'Test Community',
      'commentPicture': 'Test Comment Picture',
      'netVote': 5,
      'commentCount': 2,
      'content': 'Test Content',
      'createdAt': 'Test Date',
    };

    final searchComments = SearchComments.fromJson(json);

    expect(searchComments.id, '123');
    expect(searchComments.postID, '456');
    expect(searchComments.postTitle, 'Test Post');
    expect(searchComments.postUsername, 'Test User');
    expect(searchComments.postVotes, 10);
    expect(searchComments.postPicture, 'Test Picture');
    expect(searchComments.postCreatedAt, 'Test Date');
    expect(searchComments.isPostNSFW, false);
    expect(searchComments.isPostSpoiler, false);
    expect(searchComments.username, 'Test User');
    expect(searchComments.communityName, 'Test Community');
    expect(searchComments.commentPicture, 'Test Comment Picture');
    expect(searchComments.netVote, 5);
    expect(searchComments.commentCount, 2);
    expect(searchComments.content, 'Test Content');
    expect(searchComments.createdAt, 'Test Date');
  });

  group('SearchPosts', () {
    test('fromJson', () {
      final json = {
        '_id': '123',
        'type': 'post',
        'username': 'Test User',
        'communityName': 'Test Community',
        'profilePicture': 'Test Picture',
        'netVote': 5,
        'commentCount': 2,
        'title': 'Test Title',
        'content': 'Test Content',
        'createdAt': 'Test Date',
        'isNsfw': false,
        'isSpoiler': false,
      };

      final searchPosts = SearchPosts.fromJson(json);

      expect(searchPosts.id, '123');
      expect(searchPosts.type, 'post');
      expect(searchPosts.username, 'Test User');
      expect(searchPosts.communityName, 'Test Community');
      expect(searchPosts.profilePicture, 'Test Picture');
      expect(searchPosts.netVote, 5);
      expect(searchPosts.commentCount, 2);
      expect(searchPosts.title, 'Test Title');
      expect(searchPosts.content, 'Test Content');
      expect(searchPosts.createdAt, 'Test Date');
      expect(searchPosts.isNSFW, false);
      expect(searchPosts.isSpoiler, false);
    });
  });

  group('SearchUsers', () {
    test('fromJson', () {
      final json = {
        '_id': '123',
        'username': 'Test User',
        'about': 'Test About',
        'profilePicture': 'Test Picture',
        'isNSFW': false,
      };

      final searchUsers = SearchUsers.fromJson(json);

      expect(searchUsers.id, '123');
      expect(searchUsers.username, 'Test User');
      expect(searchUsers.about, 'Test About');
      expect(searchUsers.profilePicture, 'Test Picture');
      expect(searchUsers.isNSFW, false);
    });
  });

  group('SearchCommunities', () {
    test('fromJson', () {
      final json = {
        '_id': '123',
        'name': 'Test Community',
        'description': 'Test Description',
        'icon': 'Test Icon',
        'isNSFW': false,
        'members': 100,
      };

      final searchCommunities = SearchCommunities.fromJson(json);

      expect(searchCommunities.id, '123');
      expect(searchCommunities.name, 'Test Community');
      expect(searchCommunities.description, 'Test Description');
      expect(searchCommunities.icon, 'Test Icon');
      expect(searchCommunities.isNSFW, false);
      expect(searchCommunities.members, 100);
    });
  });

  group('SearchHashtag', () {
    test('fromJson', () {
      final json = {
        '_id': '123',
        'postID': '456',
        'postTitle': 'Test Post',
        'postUsername': 'Test User',
        'postVotes': 10,
        'postPicture': 'Test Picture',
        'postCreatedAt': '2022-01-01T00:00:00.000Z',
        'isPostNsfw': false,
        'isPostSpoiler': false,
        'communityName': 'Test Community',
        'createdAt': '2022-01-01T00:00:00.000Z',
        'username': 'Test User',
        'netVote': 5,
        'commentCount': 2,
        'commentPicture': 'Test Comment Picture',
        'content': 'Test Content',
      };

      final searchHashtag = SearchHashtag.fromJson(json);

      expect(searchHashtag.id, '123');
      expect(searchHashtag.postID, '123');
      expect(searchHashtag.postTitle, 'Test Post');
      expect(searchHashtag.postUsername, 'Test User');
      expect(searchHashtag.postVotes, 10);
      expect(searchHashtag.postPicture, 'Test Picture');
      expect(searchHashtag.postCreatedAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
      expect(searchHashtag.isPostNsfw, false);
      expect(searchHashtag.isPostSpoiler, false);
      expect(searchHashtag.communityName, 'Test Community');
      expect(searchHashtag.createdAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
      expect(searchHashtag.username, 'Test User');
      expect(searchHashtag.netVote, 5);
      expect(searchHashtag.commentCount, 2);
      expect(searchHashtag.commentPicture, 'Test Comment Picture');
      expect(searchHashtag.content, 'Test Content');
    });
  });

  group('SearchHashTagPost', () {
    test('fromJson', () {
      final json = {
        '_id': '123',
        'type': 'post',
        'username': 'Test User',
        'communityName': 'Test Community',
        'content': 'Test Content',
        'netVote': 5,
        'createdAt': '2022-01-01T00:00:00.000Z',
        'commentPicture': 'Test Comment Picture',
        'commentCount': 2,
        'postTitle': 'Test Post Title',
      };

      final searchHashTagPost = SearchHashTagPost.fromJson(json);

      expect(searchHashTagPost.id, '123');
      expect(searchHashTagPost.type, 'post');
      expect(searchHashTagPost.username, 'Test User');
      expect(searchHashTagPost.communityName, 'Test Community');
      expect(searchHashTagPost.content, 'Test Content');
      expect(searchHashTagPost.netVote, 5);
      expect(searchHashTagPost.createdAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
      expect(searchHashTagPost.commentPicture, 'Test Comment Picture');
      expect(searchHashTagPost.commentCount, 2);
      expect(searchHashTagPost.postTitle, 'Test Post Title');
    });

    test('toJson', () {
      final searchHashTagPost = SearchHashTagPost(
        id: '123',
        type: 'post',
        username: 'Test User',
        communityName: 'Test Community',
        content: 'Test Content',
        netVote: 5,
        createdAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
        commentPicture: 'Test Comment Picture',
        commentCount: 2,
        postTitle: 'Test Post Title',
      );

      final json = searchHashTagPost.toJson();

      expect(json['_id'], '123');
      expect(json['type'], 'post');
      expect(json['username'], 'Test User');
      expect(json['communityName'], 'Test Community');
      expect(json['content'], 'Test Content');
      expect(json['netVote'], 5);
      expect(json['createdAt'], '2022-01-01T00:00:00.000Z');
      expect(json['commentPicture'], 'Test Comment Picture');
      expect(json['commentCount'], 2);
      expect(json['postTitle'], 'Test Post Title');
    });
  });

  group('SearchHashtagComment', () {
    test('fromJson', () {
      final json = {
        '_id': '123',
        'type': 'comment',
        'postID': '456',
        'username': 'Test User',
        'communityName': 'Test Community',
        'content': 'Test Content',
        'netVote': 5,
        'createdAt': '2022-01-01T00:00:00.000Z',
        'postPicture': 'Test Post Picture',
        'postUsername': 'Test Post User',
        'commentPicture': 'Test Comment Picture',
        'commentCount': 2,
        'postVotes': 10,
        'postCreatedAt': '2022-01-01T00:00:00.000Z',
        'postTitle': 'Test Post Title',
        'isPostSpoiler': false,
        'isPostNsfw': false,
      };

      final searchHashtagComment = SearchHashtagComment.fromJson(json);

      expect(searchHashtagComment.id, '123');
      expect(searchHashtagComment.type, 'comment');
      expect(searchHashtagComment.postID, '456');
      expect(searchHashtagComment.username, 'Test User');
      expect(searchHashtagComment.communityName, 'Test Community');
      expect(searchHashtagComment.content, 'Test Content');
      expect(searchHashtagComment.netVote, 5);
      expect(searchHashtagComment.createdAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
      expect(searchHashtagComment.postPicture, 'Test Post Picture');
      expect(searchHashtagComment.postUsername, 'Test Post User');
      expect(searchHashtagComment.commentPicture, 'Test Comment Picture');
      expect(searchHashtagComment.commentCount, 2);
      expect(searchHashtagComment.postVotes, 10);
      expect(searchHashtagComment.postCreatedAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
      expect(searchHashtagComment.postTitle, 'Test Post Title');
      expect(searchHashtagComment.isPostSpoiler, false);
      expect(searchHashtagComment.isPostNsfw, false);
    });

    test('toJson', () {
      final searchHashtagComment = SearchHashtagComment(
        id: '123',
        type: 'comment',
        postID: '456',
        username: 'Test User',
        communityName: 'Test Community',
        content: 'Test Content',
        netVote: 5,
        createdAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
        postPicture: 'Test Post Picture',
        postUsername: 'Test Post User',
        commentPicture: 'Test Comment Picture',
        commentCount: 2,
        postVotes: 10,
        postCreatedAt: DateTime.parse('2022-01-01T00:00:00.000Z'),
        postTitle: 'Test Post Title',
        isPostSpoiler: false,
        isPostNsfw: false,
      );

      final json = searchHashtagComment.toJson();

      expect(json['_id'], '123');
      expect(json['type'], 'comment');
      expect(json['postID'], '456');
      expect(json['username'], 'Test User');
      expect(json['communityName'], 'Test Community');
      expect(json['content'], 'Test Content');
      expect(json['netVote'], 5);
      expect(json['createdAt'], '2022-01-01T00:00:00.000Z');
      expect(json['postPicture'], 'Test Post Picture');
      expect(json['postUsername'], 'Test Post User');
      expect(json['commentPicture'], 'Test Comment Picture');
      expect(json['commentCount'], 2);
      expect(json['postVotes'], 10);
      expect(json['postCreatedAt'], '2022-01-01T00:00:00.000Z');
      expect(json['postTitle'], 'Test Post Title');
      expect(json['isPostSpoiler'], false);
      expect(json['isPostNsfw'], false);
    });
  });
}

/*
import 'package:flutter_test/flutter_test.dart';
import 'package:your_package/search.dart';

void main() {
  
}

*/