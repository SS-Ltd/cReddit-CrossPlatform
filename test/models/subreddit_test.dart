import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/subreddit.dart';

void main() {
  test('Subreddit fromJson', () {
    final json = {
      'name': 'testSubreddit',
      'icon': 'https://example.com/icon.png',
      'banner': 'https://example.com/banner.png',
      'members': 100,
      'rules': [
        {'text': 'Rule 1'},
        {'text': 'Rule 2'},
      ],
      'moderators': [
        {'username': 'mod1', 'profilePicture': 'https://example.com/mod1.png'},
        {'username': 'mod2', 'profilePicture': 'https://example.com/mod2.png'},
      ],
      'description': 'This is a test subreddit.',
      'isMember': false,
      'isNSFW': false,
      'isModerator': false,
    };

    final subreddit = Subreddit.fromJson(json);

    expect(subreddit.name, 'testSubreddit');
    expect(subreddit.icon, 'https://example.com/icon.png');
    expect(subreddit.banner, 'https://example.com/banner.png');
    expect(subreddit.members, 100);
    expect(subreddit.rules, ['Rule 1', 'Rule 2']);
    expect(subreddit.moderators, ['mod1', 'mod2']);
    expect(subreddit.description, 'This is a test subreddit.');
    expect(subreddit.isMember, false);
    expect(subreddit.isNSFW, false);
    expect(subreddit.isModerator, false);
  });
}