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
  final String? communityName;
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
      this.communityName = '',
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
  final String? id;
  final String username;
  final String? about;
  final String profilePicture;
  final bool? isNSFW;

  SearchUsers(
      {this.id = '',
      required this.username,
      this.about = '',
      required this.profilePicture,
      this.isNSFW = false});

  factory SearchUsers.fromJson(Map<String, dynamic> json) {
    return SearchUsers(
      id: json['_id'],
      username: json['username'],
      about: json['about'],
      profilePicture: json['profilePicture'],
      isNSFW: json['isNSFW'],
    );
  }
}

class SearchCommunities {
  final String? id;
  final String name;
  final String? description;
  final String icon;
  final bool isNSFW;
  final int members;

  SearchCommunities(
      {this.id = '',
      required this.name,
      this.description = '',
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

class SearchHashtag {
  final String id;
  final String postID;
  final String postTitle;
  final String postUsername;
  final int postVotes;
  final String postPicture;
  final DateTime postCreatedAt;
  final bool isPostNsfw;
  final bool isPostSpoiler;
  final String communityName;
  final DateTime createdAt;
  final String username;
  final int netVote;
  final int commentCount;
  final String commentPicture;
  final String content;

  SearchHashtag({
    required this.id,
    required this.postID,
    required this.postTitle,
    required this.postUsername,
    required this.postVotes,
    required this.postPicture,
    required this.postCreatedAt,
    required this.isPostNsfw,
    required this.isPostSpoiler,
    required this.communityName,
    required this.createdAt,
    required this.username,
    required this.netVote,
    required this.commentCount,
    required this.commentPicture,
    required this.content,
  });

  factory SearchHashtag.fromJson(Map<String, dynamic> json) {
    return SearchHashtag(
      id: json['_id'],
      postID: json['_id'],
      postTitle: json['postTitle'],
      postUsername: json['postUsername'],
      postVotes: json['postVotes'],
      postPicture: json['postPicture'],
      postCreatedAt: DateTime.parse(json['postCreatedAt']),
      isPostNsfw: json['isPostNsfw'],
      isPostSpoiler: json['isPostSpoiler'],
      communityName: json['communityName'],
      createdAt: DateTime.parse(json['createdAt']),
      username: json['username'],
      netVote: json['netVote'],
      commentCount: json['commentCount'],
      commentPicture: json['commentPicture'],
      content: json['content'],
    );
  }
}

class SearchHashTagPost {
  final String id;
  final String type;
  final String username;
  final String communityName;
  final String content;
  final int netVote;
  final DateTime createdAt;
  final String commentPicture;
  final int commentCount;
  final String postTitle;

  SearchHashTagPost({
    required this.id,
    required this.type,
    required this.username,
    required this.communityName,
    required this.content,
    required this.netVote,
    required this.createdAt,
    required this.commentPicture,
    required this.commentCount,
    required this.postTitle,
  });

  factory SearchHashTagPost.fromJson(Map<String, dynamic> json) {
    return SearchHashTagPost(
      id: json['_id'],
      type: json['type'],
      username: json['username'],
      communityName: json['communityName'] ?? "",
      content: json['content'],
      netVote: json['netVote'],
      createdAt: DateTime.parse(json['createdAt']),
      commentPicture: json['commentPicture'],
      commentCount: json['commentCount'],
      postTitle: json['postTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'username': username,
      'communityName': communityName,
      'content': content,
      'netVote': netVote,
      'createdAt': createdAt.toIso8601String(),
      'commentPicture': commentPicture,
      'commentCount': commentCount,
      'postTitle': postTitle,
    };
  }
}

class SearchHashtagComment {
  final String id;
  final String type;
  final String postID;
  final String username;
  final String? communityName;
  final String content;
  final int netVote;
  final DateTime createdAt;
  final String postPicture;
  final String postUsername;
  final String commentPicture;
  final int commentCount;
  final int postVotes;
  final DateTime postCreatedAt;
  final String postTitle;
  final bool isPostSpoiler;
  final bool isPostNsfw;

  SearchHashtagComment({
    required this.id,
    required this.type,
    required this.postID,
    required this.username,
    this.communityName,
    required this.content,
    required this.netVote,
    required this.createdAt,
    required this.postPicture,
    required this.postUsername,
    required this.commentPicture,
    required this.commentCount,
    required this.postVotes,
    required this.postCreatedAt,
    required this.postTitle,
    required this.isPostSpoiler,
    required this.isPostNsfw,
  });

  factory SearchHashtagComment.fromJson(Map<String, dynamic> json) {
    return SearchHashtagComment(
      id: json['_id'],
      type: json['type'],
      postID: json['postID'],
      username: json['username'],
      communityName: json['communityName'] ?? "",
      content: json['content'],
      netVote: json['netVote'],
      createdAt: DateTime.parse(json['createdAt']),
      postPicture: json['postPicture'],
      postUsername: json['postUsername'],
      commentPicture: json['commentPicture'],
      commentCount: json['commentCount'],
      postVotes: json['postVotes'],
      postCreatedAt: DateTime.parse(json['postCreatedAt']),
      postTitle: json['postTitle'],
      isPostSpoiler: json['isPostSpoiler'],
      isPostNsfw: json['isPostNsfw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'postID': postID,
      'username': username,
      'communityName': communityName,
      'content': content,
      'netVote': netVote,
      'createdAt': createdAt.toIso8601String(),
      'postPicture': postPicture,
      'postUsername': postUsername,
      'commentPicture': commentPicture,
      'commentCount': commentCount,
      'postVotes': postVotes,
      'postCreatedAt': postCreatedAt.toIso8601String(),
      'postTitle': postTitle,
      'isPostSpoiler': isPostSpoiler,
      'isPostNsfw': isPostNsfw,
    };
  }
}
