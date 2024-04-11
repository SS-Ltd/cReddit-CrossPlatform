class SavedCommentsModel {
  final String username;
  final String communityName;
  final bool isUpvoted;
  final bool isDownvoted;
  final String commentId;
  final bool isImage;
  final int netVote;
  final String content;
  final String createdAt;
  final String postId;
  final String title;

  SavedCommentsModel({
    required this.username,
    required this.isImage,
    required this.netVote,
    required this.content,
    required this.createdAt,
    required this.commentId,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.communityName,
    required this.postId,
    this.title = '',
  });

  factory SavedCommentsModel.fromJson(Map<String, dynamic> json) {
    return SavedCommentsModel(
      username: json['username'],
      isImage: json['isImage'] == null ? false : json['isImage'],
      netVote: json['netVote'],
      content: json['content'],
      createdAt: json['createdAt'],
      commentId: json['_id'],
      isUpvoted: json['isUpvoted'],
      isDownvoted: json['isDownvoted'],
      communityName: json['communityName'] == null
          ? json['parentPostUsername']
          : json['communityName'],
      postId: json['postID'],
      title: json['title'] ?? '',
    );
  }
}
