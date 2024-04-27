class PostModel {
  final String postId;
  final String type;
  final String username;
  final String communityName;
  final String title;
  final String content;
  final List<PollsOption>? pollOptions;
  final DateTime? expirationDate;
  int netVote;
  final bool isSpoiler;
  final bool isLocked;
  final bool isApproved;
  final bool isEdited;
  final DateTime createdAt;
  final DateTime updatedAt;
  // final List<String> reports; // need type to be checked
  final String profilePicture;
  final int commentCount;
  final bool isDeletedUser;
  bool isUpvoted;
  bool isDownvoted;
  final bool isSaved;
  final bool isHidden;
  final bool isJoined;
  final bool isModerator;
  bool? isBlocked;
  // final DateTime? uploadDate;
  final bool isNSFW;  

  PostModel({
    required this.postId,
    required this.type,
    required this.username,
    required this.communityName,
    required this.title,
    required this.content,
    required this.pollOptions,
    required this.expirationDate,
    required this.netVote,
    required this.isSpoiler,
    required this.isLocked,
    required this.isApproved,
    required this.isEdited,
    required this.createdAt,
    required this.updatedAt,
    // required this.reports,
    required this.profilePicture,
    required this.commentCount,
    required this.isDeletedUser,
    required this.isUpvoted,
    required this.isDownvoted,
    required this.isSaved,
    required this.isHidden,
    required this.isJoined,
    required this.isModerator,
    this.isBlocked,
    required this.isNSFW,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return PostModel(
      postId: json['_id'],
      type: json['type'],
      username: json['username'],
      communityName: json['communityName'],
      title: json['title'],
      content: json['content'],
      pollOptions: json['pollOptions'] != null
          ? (json['pollOptions'] as List)
              .map((e) => PollsOption.fromJson(e))
              .toList()
          : null,
      expirationDate: json['expirationDate'] != null
          ? DateTime.parse(json['expirationDate'])
          : null,
      netVote: json['netVote'],
      isSpoiler: json['isSpoiler'],
      isLocked: json['isLocked'],
      isApproved: json['isApproved'],
      isEdited: json['isEdited'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      // reports: json['reports'],
      profilePicture: json['profilePicture'],
      commentCount: json['commentCount'],
      isDeletedUser: json['isDeletedUser'],
      isUpvoted: json['isUpvoted'],
      isDownvoted: json['isDownvoted'],
      isSaved: json['isSaved'],
      isHidden: json['isHidden'],
      isJoined: json['isJoined'],
      isModerator: json['isModerator'],
      isBlocked: json['isBlocked'],
      isNSFW: json['isNSFW'],
    );
  }
}

class PollsOption {
  final String? option;
  final bool? isVoted;
  final int? votes;

  PollsOption(
      {required this.option, required this.isVoted, required this.votes});

  factory PollsOption.fromJson(Map<String, dynamic> json) {
    print(json);
    return PollsOption(
      option: json['text'],
      isVoted: json['isVoted'],
      votes: json['votes'],
    );
  }
}
