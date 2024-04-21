class SearchComments {
  final String id;
  final String postID;
  final String postTitle;
  final String postUsername;
  final int postVotes;
  final String postPicture;
  final String postCreatedAt;
  final bool isPostNSFW;
  final bool isPostSpoiler;
  final String username;
  final String? communityName;
  final String commentPicture;
  final int netVote;
  final int commentCount;
  final String content;
  final String createdAt;

  SearchComments(
      {required this.id,
      required this.postID,
      required this.postTitle,
      required this.postUsername,
      required this.postVotes,
      required this.postPicture,
      required this.postCreatedAt,
      required this.isPostNSFW,
      required this.isPostSpoiler,
      required this.username,
      this.communityName = '',
      required this.commentPicture,
      required this.netVote,
      required this.commentCount,
      required this.content,
      required this.createdAt});

  factory SearchComments.fromJson(Map<String, dynamic> json) {
    return SearchComments(
      id: json['_id'],
      postID: json['postID'],
      postTitle: json['postTitle'],
      postUsername: json['postUsername'],
      postVotes: json['postVotes'],
      postPicture: json['postPicture'],
      postCreatedAt: json['postCreatedAt'],
      isPostNSFW: json['isPostNsfw'],
      isPostSpoiler: json['isPostSpoiler'],
      username: json['username'],
      communityName: json['communityName'],
      commentPicture: json['commentPicture'],
      netVote: json['netVote'],
      commentCount: json['commentCount'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}

class SearchPosts {
  final String id;
  final String type;
  final String username;
  final String communityName;
  final String profilePicture;
  final int netVote;
  final int commentCount;
  final String title;
  final String content;
  final String createdAt;
  final bool isNSFW;
  final bool isSpoiler;

  SearchPosts(
      {required this.id,
      required this.type,
      required this.username,
      required this.communityName,
      required this.profilePicture,
      required this.netVote,
      required this.commentCount,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.isNSFW,
      required this.isSpoiler});

  factory SearchPosts.fromJson(Map<String, dynamic> json) {
    return SearchPosts(
      id: json['_id'],
      type: json['type'],
      username: json['username'],
      communityName: json['communityName'],
      profilePicture: json['profilePicture'],
      netVote: json['netVote'],
      commentCount: json['commentCount'],
      title: json['title'],
      content: json['content'],
      createdAt: json['createdAt'],
      isNSFW: json['isNsfw'],
      isSpoiler: json['isSpoiler'],
    );
  }
}

class SearchUsers {
  final String id;
  final String username;
  final String about;
  final String profilePicture;
  final bool isMod;

  SearchUsers(
      {required this.id,
      required this.username,
      required this.about,
      required this.profilePicture,
      required this.isMod});

  factory SearchUsers.fromJson(Map<String, dynamic> json) {
    return SearchUsers(
      id: json['id'],
      username: json['username'],
      about: json['about'],
      profilePicture: json['profilePicture'],
      isMod: json['isMod'],
    );
  }
}

class SearchCommunities {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isNSFW;
  final int members;

  SearchCommunities(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.isNSFW,
      required this.members});

  factory SearchCommunities.fromJson(Map<String, dynamic> json) {
    return SearchCommunities(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      isNSFW: json['isNSFW'],
      members: json['members'],
    );
  }
}
