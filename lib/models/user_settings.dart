class UserSettings {
  final Account account;
  final Profile profile;
  final SafetyAndPrivacy safetyAndPrivacy;
  final FeedSettings feedSettings;
  final Notifications notifications;
  final EmailSettings emailSettings;

  UserSettings({
    required this.account,
    required this.profile,
    required this.safetyAndPrivacy,
    required this.feedSettings,
    required this.notifications,
    required this.emailSettings,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      account: Account.fromJson(json['account']),
      profile: Profile.fromJson(json['profile']),
      safetyAndPrivacy: SafetyAndPrivacy.fromJson(json['safetyAndPrivacy']),
      feedSettings: FeedSettings.fromJson(json['feedSettings']),
      notifications: Notifications.fromJson(json['notifications']),
      emailSettings: EmailSettings.fromJson(json['email']),
    );
  }
}

class Account {
  final String email;
  final String gender;
  final bool google;

  Account({required this.email, required this.gender, required this.google});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      email: json['email'],
      gender: json['gender'],
      google: json['google'],
    );
  }
}

class Profile {
  final String displayName;
  final String? about;
  final List<SocialLink> socialLinks;
  final String? avatar;
  final String? banner;
  final bool isNSFW;
  final bool allowFollow;
  final bool isContentVisible;

  Profile({
    required this.displayName,
    required this.about,
    required this.socialLinks,
    required this.avatar,
    required this.banner,
    required this.isNSFW,
    required this.allowFollow,
    required this.isContentVisible,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    print(json['displayName']);
    print(json['about']);
    print(json['socialLinks']);
    print(json['avatar']);
    print(json['banner']);
    print(json['isNSFW']);
    print(json['allowFollow']);
    print(json['isContentVisible']);
    List<SocialLink> socialLinks = (json['socialLinks'] as List)
        .map((socialLinkJson) => SocialLink.fromJson(socialLinkJson))
        .toList();

    return Profile(
      displayName: json['displayName'],
      about: json['about'],
      socialLinks: socialLinks,
      avatar: json['avatar'],
      banner: json['banner'],
      isNSFW: json['isNSFW'],
      allowFollow: json['allowFollow'],
      isContentVisible: json['isContentVisible'],
    );
  }
}

class SocialLink {
  final String displayName;
  final String platform;
  final String url;

  SocialLink(
      {required this.displayName, required this.platform, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      displayName: json['displayName'],
      platform: json['platform'],
      url: json['url'],
    );
  }
}

class SafetyAndPrivacy {
  final List<String> blockedUsers;
  final List<String> mutedCommunities;

  SafetyAndPrivacy({
    required this.blockedUsers,
    required this.mutedCommunities,
  });

  factory SafetyAndPrivacy.fromJson(Map<String, dynamic> json) {
    return SafetyAndPrivacy(
      blockedUsers: List<String>.from(json['blockedUsers']),
      mutedCommunities: List<String>.from(json['mutedCommunities']),
    );
  }
}

class FeedSettings {
  final bool showAdultContent;
  final bool autoPlayMedia;
  final bool communityThemes;
  final String communityContentSort;
  final String globalContentView;
  final bool openNewTab;

  FeedSettings({
    required this.showAdultContent,
    required this.autoPlayMedia,
    required this.communityThemes,
    required this.communityContentSort,
    required this.globalContentView,
    required this.openNewTab,
  });

  factory FeedSettings.fromJson(Map<String, dynamic> json) {
    return FeedSettings(
      showAdultContent: json['showAdultContent'],
      autoPlayMedia: json['autoPlayMedia'],
      communityThemes: json['communityThemes'],
      communityContentSort: json['communityContentSort'],
      globalContentView: json['globalContentView'],
      openNewTab: json['openNewTab'],
    );
  }
}

class Notifications {
  final bool? mentionsNotifs;
  final bool? commentsNotifs;
  final bool? postsUpvotesNotifs;
  final bool? repliesNotifs;
  final bool? newFollowersNotifs;
  final bool? postNotifs;
  final bool? cakeDayNotifs;
  final bool? modNotifs;
  final List<String>? moderatorInCommunities;
  final bool? invitationNotifs;

  Notifications({
    required this.mentionsNotifs,
    required this.commentsNotifs,
    required this.postsUpvotesNotifs,
    required this.repliesNotifs,
    required this.newFollowersNotifs,
    required this.postNotifs,
    required this.cakeDayNotifs,
    required this.modNotifs,
    required this.moderatorInCommunities,
    required this.invitationNotifs,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      mentionsNotifs: json['mentionsNotifs'],
      commentsNotifs: json['commentsNotifs'],
      postsUpvotesNotifs: json['postsUpvotesNotifs'],
      repliesNotifs: json['repliesNotifs'],
      newFollowersNotifs: json['newFollowersNotifs'],
      postNotifs: json['postNotifs'],
      cakeDayNotifs: json['cakeDayNotifs'],
      modNotifs: json['modNotifs'],
      moderatorInCommunities: List<String>.from(json['moderatorInCommunities']),
      invitationNotifs: json['invitationNotifs'],
    );
  }
}

class EmailSettings {
  final bool? followEmail;
  final bool? chatEmail;

  EmailSettings({
    required this.followEmail,
    required this.chatEmail,
  });

  factory EmailSettings.fromJson(Map<String, dynamic> json) {
    return EmailSettings(
      followEmail: json['followEmail'],
      chatEmail: json['chatEmail'],
    );
  }
}
