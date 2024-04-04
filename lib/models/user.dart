class UserModel {
  final String username;

  bool isLoggedIn = false;
  final List<String> recentlyVisited = [];

  UserModel(this.username);

  void updateUserStatus(bool status) {
    isLoggedIn = status;
  }

  void setrecentlyVisited(String communityName) {
    recentlyVisited.add(communityName);
  }

  List<String> getrecentlyvisited(){
    return recentlyVisited;
  }
}
