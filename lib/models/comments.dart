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
  final String? postId;
  final String? title;
  ValueNotifier<bool> isDeleted = ValueNotifier(false);
  ValueNotifier<bool> isBlocked = ValueNotifier(false);
  bool isApproved;

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
    this.isApproved = false,
  });

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      profilePicture:
          json['profilePicture'] is String ? json['profilePicture'] : '',
      username: json['username'],
      isImage: json['isImage'] ?? false,
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
      isApproved: json['isApproved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profilePicture': profilePicture,
      'username': username,
      'isImage': isImage,
      'netVote': netVote,
      'content': content,
      'createdAt': createdAt,
      '_id': commentId,
      'isUpvoted': isUpvoted,
      'isDownvoted': isDownvoted,
      'isSaved': isSaved,
      'communityName': communityName,
      'postID': postId,
      'title': title,
      'isApproved': isApproved,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comments &&
        other.profilePicture == profilePicture &&
        other.username == username &&
        other.isImage == isImage &&
        other.netVote == netVote &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.commentId == commentId &&
        other.isUpvoted == isUpvoted &&
        other.isDownvoted == isDownvoted &&
        other.isSaved == isSaved &&
        other.communityName == communityName &&
        other.postId == postId &&
        other.title == title &&
        other.isApproved == isApproved;
  }

  @override
  int get hashCode {
    return profilePicture.hashCode ^
        username.hashCode ^
        isImage.hashCode ^
        netVote.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        commentId.hashCode ^
        isUpvoted.hashCode ^
        isDownvoted.hashCode ^
        isSaved.hashCode ^
        communityName.hashCode ^
        postId.hashCode ^
        title.hashCode ^
        isApproved.hashCode;
  }
}
