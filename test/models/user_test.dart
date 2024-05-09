import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';

void main() {
  group('UserModel', () {
    final json = {
      'username': 'testuser',
      'displayName': 'Test User',
      'about': 'About Test User',
      'email': 'testuser@example.com',
      'profilePicture': 'https://example.com/profile.png',
      'banner': 'https://example.com/banner.png',
      'followers': 100,
      'cakeDay': '2022-01-01T00:00:00.000',
      'isBlocked': false,
    };

    final user = UserModel(
      username: 'testuser',
      displayName: 'Test User',
      about: 'About Test User',
      email: 'testuser@example.com',
      profilePicture: 'https://example.com/profile.png',
      banner: 'https://example.com/banner.png',
      followers: 100,
      cakeDay: DateTime.parse('2022-01-01T00:00:00.000'),
      isBlocked: false,
    );

    test('fromJson', () {
      expect(UserModel.fromJson(json), user);
    });

    test('updateUserStatus', () {
      user.updateUserStatus(true);
      expect(user.isLoggedIn, true);
    });

    test('setrecentlyVisited', () {
      final subreddit = Subreddit(
        name: 'testSubreddit',
        icon: 'https://example.com/icon.png',
        banner: 'https://example.com/banner.png',
        members: 100,
        rules: ['Rule 1', 'Rule 2'],
        moderators: ['mod1', 'mod2'],
        description: 'This is a test subreddit.',
        isMember: false,
        isNSFW: false,
        isModerator: false,
      );
      user.setrecentlyVisited(subreddit);
      expect(user.getrecentlyvisited(), contains(subreddit));
    });

    test('setrecentlySearch', () {
      user.setrecentlySearch('test');
      expect(user.getrecentlySearch(), contains('test'));
    });

    test('setmoderators', () {
      final subreddit = Subreddit(
        name: 'testSubreddit',
        icon: 'https://example.com/icon.png',
        banner: 'https://example.com/banner.png',
        members: 100,
        rules: ['Rule 1', 'Rule 2'],
        moderators: ['mod1', 'mod2'],
        description: 'This is a test subreddit.',
        isMember: false,
        isNSFW: false,
        isModerator: false,
      );
      user.setmoderators([subreddit]);
      expect(user.getmoderators(), contains(subreddit));
    });
  });
}
