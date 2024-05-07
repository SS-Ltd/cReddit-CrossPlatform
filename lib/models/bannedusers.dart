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
  final String modNote;

  BannedUser({required this.name, required this.reasonToBan, required this.modNote});

  factory BannedUser.fromJson(Map<String, dynamic> json) {
    return BannedUser(
      name: json['name'],
      reasonToBan: json['reasonToBan'],
      modNote: json['modNote'],
    );
  }
}