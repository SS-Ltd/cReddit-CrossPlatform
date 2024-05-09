import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_clone/models/user_settings.dart';

void main() {
  test('UserSettings fromJson', () {
    final json = {
      'account': {
        'email': 'test@example.com',
        'gender': 'male',
        'google': true,
      },
      'profile': {
        'displayName': 'Test User',
        'about': 'About Test User',
        'socialLinks': [
          {
            'displayName': 'Test Link',
            'platform': 'Test Platform',
            'url': 'https://test.com',
          },
        ],
        'avatar': 'https://test.com/avatar.png',
        'banner': 'https://test.com/banner.png',
        'isNSFW': false,
        'allowFollow': true,
        'isContentVisible': true,
      },
      'safetyAndPrivacy': {
        'blockedUsers': [
          {
            'username': 'Blocked User',
            'profilePicture': 'https://test.com/blocked.png',
          },
        ],
        'mutedCommunities': [
          {
            'name': 'Muted Community',
            'profilePicture': 'https://test.com/muted.png',
          },
        ],
      },
      'feedSettings': {
        'showAdultContent': false,
        'autoPlayMedia': true,
        'communityThemes': true,
        'communityContentSort': 'Hot',
        'globalContentView': 'Card',
        'openNewTab': false,
      },
      'notifications': {
        'mentionsNotifs': true,
        'commentsNotifs': true,
        'postsUpvotesNotifs': true,
        'repliesNotifs': true,
        'newFollowersNotifs': true,
        'postNotifs': true,
        'cakeDayNotifs': true,
        'modNotifs': true,
        'moderatorInCommunities': ['Test Community'],
        'invitationNotifs': true,
      },
      'email': {
        'followEmail': true,
        'chatEmail': true,
      },
    };

    final userSettings = UserSettings.fromJson(json);

    expect(userSettings.account.email, 'test@example.com');
    expect(userSettings.account.gender, 'male');
    expect(userSettings.account.google, true);
    expect(userSettings.profile.displayName, 'Test User');
    expect(userSettings.profile.about, 'About Test User');
    expect(userSettings.profile.socialLinks[0].displayName, 'Test Link');
    expect(userSettings.profile.socialLinks[0].platform, 'Test Platform');
    expect(userSettings.profile.socialLinks[0].url, 'https://test.com');
    expect(userSettings.profile.avatar, 'https://test.com/avatar.png');
    expect(userSettings.profile.banner, 'https://test.com/banner.png');
    expect(userSettings.profile.isNSFW, false);
    expect(userSettings.profile.allowFollow, true);
    expect(userSettings.profile.isContentVisible, true);
    expect(userSettings.safetyAndPrivacy.blockedUsers[0].username, 'Blocked User');
    expect(userSettings.safetyAndPrivacy.blockedUsers[0].profilePicture, 'https://test.com/blocked.png');
    expect(userSettings.safetyAndPrivacy.mutedCommunities[0].name, 'Muted Community');
    expect(userSettings.safetyAndPrivacy.mutedCommunities[0].profilePicture, 'https://test.com/muted.png');
    expect(userSettings.feedSettings.showAdultContent, false);
    expect(userSettings.feedSettings.autoPlayMedia, true);
    expect(userSettings.feedSettings.communityThemes, true);
    expect(userSettings.feedSettings.communityContentSort, 'Hot');
    expect(userSettings.feedSettings.globalContentView, 'Card');
    expect(userSettings.feedSettings.openNewTab, false);
    expect(userSettings.notifications.mentionsNotifs, true);
    expect(userSettings.notifications.commentsNotifs, true);
    expect(userSettings.notifications.postsUpvotesNotifs, true);
    expect(userSettings.notifications.repliesNotifs, true);
    expect(userSettings.notifications.newFollowersNotifs, true);
    expect(userSettings.notifications.postNotifs, true);
    expect(userSettings.notifications.cakeDayNotifs, true);
    expect(userSettings.notifications.modNotifs, true);
    expect(userSettings.notifications.moderatorInCommunities![0], 'Test Community');
    expect(userSettings.notifications.invitationNotifs, true);
    expect(userSettings.emailSettings.followEmail, true);
    expect(userSettings.emailSettings.chatEmail, true);
  });
}