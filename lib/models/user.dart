class UserModel {
  final String username;
  bool isLoggedIn = false;

  UserModel(this.username);

  void updateUserStatus(bool status) {
    isLoggedIn = status;
  }
}
