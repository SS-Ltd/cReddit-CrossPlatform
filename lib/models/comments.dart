class Comments {
  final String profilePicture;
  final String username;
  final bool isImage;
  final int netVote;
  final String content;
  final String createdAt;
  final String commentId;
  final bool isUpvoted;
  final bool isDownvoted;
  final bool isSaved;
  Comments({
    required this.profilePicture,
    required this.username,
    required this.isImage,
    required this.netVote,
    required this.content,
    required this.createdAt,
    required this.commentId,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.isSaved,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      profilePicture: json['profilePicture'],
      username: json['username'],
      isImage: json['isImage'],
      netVote: json['netVote'],
      content: json['content'],
      createdAt: json['createdAt'],
      commentId: json['_id'],
      isUpvoted: json['isUpvoted'],
      isDownvoted: json['isDownvoted'],
      isSaved: !json['isSaved'],
    );
  }
}
