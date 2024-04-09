class UserModel {
  final String username;
  final String displayName;
  final String? about;
  final String email;
  final String profilePicture;
  final String? banner;
  final int followers;
  final DateTime cakeDay;
  bool isLoggedIn = false;

  UserModel({
    required this.username,
    required this.displayName,
    this.about,
    required this.email,
    required this.profilePicture,
    this.banner,
    required this.followers,
    required this.cakeDay,
  });

  void updateUserStatus(bool status) {
    isLoggedIn = status;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print(json);
    return UserModel(
      username: json['username'],
      displayName: json['displayName'],
      about: json['about'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      banner: json['banner'],
      followers: json['followers'],
      cakeDay: DateTime.parse(json['cakeDay']),
    );
  }
}
