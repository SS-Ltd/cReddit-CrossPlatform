class JoinedCommunitites {
  JoinedCommunitites(
      {required this.members,
      required this.profilePicture,
      required this.name});

  String name;
  String profilePicture;
  int members;

  factory JoinedCommunitites.fromJson(Map<String, dynamic> json) {
    return JoinedCommunitites(
      members: json['members'],
      profilePicture: json['profilePicture'],
      name: json['communityName'],
    );
  }
}
