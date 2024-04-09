class PostModel {
  final String postId;
  final String type;
  final String username;
  final String? communityName;
  final String title;
  final String content;
  final String profilePicture;
  final int netVote;
  final int commentCount;
  final bool? isNSFW;
  final bool? isSpoiler;
  final bool? isApproved;
  final bool isUpvoted;
  final bool isDownvoted;
  final bool? isHidden;
  final bool? isSaved;
  final DateTime uploadDate;
  final List<PollOption>? pollOptions;
  final DateTime? expirationDate;

  PostModel({
    required this.postId,
    required this.type,
    required this.username,
    required this.communityName,
    required this.title,
    required this.content,
    required this.profilePicture,
    required this.netVote,
    required this.commentCount,
    required this.isNSFW,
    required this.isSpoiler,
    required this.isApproved,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.isHidden,
    required this.isSaved,
    required this.uploadDate,
    this.pollOptions,
    this.expirationDate,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['_id'],
      type: json['type'],
      username: json['username'],
      communityName: json['communityName'],
      title: json['title'],
      content: json['content'],
      profilePicture: json['profilePicture'],
      netVote: json['netVote'],
      commentCount: json['commentCount'],
      isNSFW: json['isNSFW'],
      isSpoiler: json['isSpoiler'],
      isApproved: json['isApproved'],
      isUpvoted: json['isUpvoted'],
      isDownvoted: json['isDownvoted'],
      isHidden: json['isHidden'],
      isSaved: json['isSaved'],
      uploadDate: DateTime.parse(json['createdAt']),
      pollOptions: json['pollOptions'] != null
          ? (json['pollOptions'] as List)
              .map((e) => PollOption.fromJson(e))
              .toList()
          : null,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
    );
  }
}

class PollOption {
  final String? option;
  final bool? isVoted;
  final int? votes;

  PollOption(
      {required this.option, required this.isVoted, required this.votes});

  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      option: json['option'],
      isVoted: json['isVoted'],
      votes: json['votes'],
    );
  }
}
