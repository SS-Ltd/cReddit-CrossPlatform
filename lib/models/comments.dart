import 'package:flutter/foundation.dart';
class Comments {
  final String profilePicture;
  String username;
  final bool isImage;
  final int netVote;
  final String content;
  final String createdAt;
  final String commentId;
  final bool isUpvoted;
  final bool isDownvoted;
  bool isSaved;

  String? communityName;
  final String? postId; //
  final String? title; //
  ValueNotifier<bool> isDeleted =ValueNotifier(false);
  ValueNotifier<bool> isBlocked =ValueNotifier(false);

  Comments({
    required this.profilePicture,
    required this.username,
    required this.isImage,
    required this.netVote,
    required this.content,
    required this.createdAt,
    required this.commentId,
    this.isUpvoted = false,
    this.isDownvoted = false,
    this.isSaved = false,
    this.communityName = '',
    this.postId = '',
    this.title = '',
    
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      profilePicture:
          json['profilePicture'] is String ? json['profilePicture'] : '',
      username: json['username'],
      isImage: json['isImage'] == null ? false : json['isImage'],
      netVote: json['netVote'],
      content: json['content'],
      createdAt: json['createdAt'],
      commentId: json['_id'],
      isUpvoted: json['isUpvoted'],
      isDownvoted: json['isDownvoted'],
      isSaved: json['isSaved'],
      communityName: json['communityName'] ?? json['parentPostUsername'] ?? '',
      postId: json['postID'] is String ? json['postID'] : '',
      title: json['title'] ?? '',
    );
  }
}
