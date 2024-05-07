class BannedUserList {
  final List<BannedUser> bannedUsers;

  BannedUserList({required this.bannedUsers});

  factory BannedUserList.fromJson(Map<String, dynamic> json) {
    var list = json['bannedUsers'] as List;
    List<BannedUser> bannedUserList = list.map((i) => BannedUser.fromJson(i)).toList();

    return BannedUserList(
      bannedUsers: bannedUserList,
    );
  }
}

class BannedUser {
  final String name;
  final String reasonToBan;
  final String? modNote;
  final int? days;       // 0 means permenant

  BannedUser({required this.name, required this.reasonToBan, this.modNote, required this.days});

  factory BannedUser.fromJson(Map<String, dynamic> json) {
    return BannedUser(
      name: json['username'],
      reasonToBan: json['reasonToBan'],
      modNote: json['modNote'],
      days: json['days'] ?? 0,
    );
  }
}