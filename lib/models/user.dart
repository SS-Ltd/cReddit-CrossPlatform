import 'package:reddit_clone/models/subreddit.dart';

class UserModel {
  final String username;
  final String displayName;
  final String? about;
  final String email;
  final String profilePicture;
  final String? banner;
  final int followers;
  final DateTime cakeDay;
  bool isLoggedIn = false;
  final Set<Subreddit> recentlyVisited = {};
  final List<String> recentlySearch= [];
  final bool isBlocked;
  final List<Subreddit> moderator = [];

  UserModel({
    required this.username,
    required this.displayName,
    this.about,
    required this.email,
    required this.profilePicture,
    this.banner,
    required this.followers,
    required this.cakeDay,
    required this.isBlocked,
  });

  void updateUserStatus(bool status) {
    isLoggedIn = status;
  }

  void setrecentlyVisited(Subreddit communityName) {
    recentlyVisited.add(communityName);
  }

  void setrecentlySearch(String searchData){
    recentlySearch.add(searchData);
  }

  void setmoderators(List<Subreddit> communities){
    moderator.addAll(communities);
  }

  Set<Subreddit> getrecentlyvisited() {
    return recentlyVisited;
  }

  List<String> getrecentlySearch(){
    return recentlySearch;
  }

  List<Subreddit> getmoderators(){
    return moderator;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      displayName: json['displayName'],
      about: json['about'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      banner: json['banner'],
      followers: json['followers'],
      cakeDay: DateTime.parse(json['cakeDay']),
      isBlocked: json['isBlocked'] ?? false,
      //isNFSW : json['isNSFW'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.username == username &&
        other.displayName == displayName &&
        other.about == about &&
        other.email == email &&
        other.profilePicture == profilePicture &&
        other.banner == banner &&
        other.followers == followers &&
        other.cakeDay == cakeDay &&
        other.isBlocked == isBlocked;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        displayName.hashCode ^
        about.hashCode ^
        email.hashCode ^
        profilePicture.hashCode ^
        banner.hashCode ^
        followers.hashCode ^
        cakeDay.hashCode ^
        isBlocked.hashCode;
  }

}
