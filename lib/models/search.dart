class SearchModel {
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
  final String communityName;
  final String commentPicture;
  final int netVote;
  final int commentCount;
  final String content;
  final String createdAt;

  SearchModel(
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
      required this.communityName,
      required this.commentPicture,
      required this.netVote,
      required this.commentCount,
      required this.content,
      required this.createdAt});

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      id: json['id'],
      postID: json['postID'],
      postTitle: json['postTitle'],
      postUsername: json['postUsername'],
      postVotes: json['postVotes'],
      postPicture: json['postPicture'],
      postCreatedAt: json['postCreatedAt'],
      isPostNSFW: json['isPostNSFW'],
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
