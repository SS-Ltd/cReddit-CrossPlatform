import 'package:reddit_clone/models/subreddit.dart';

class UserModel {
  final String username;

  bool isLoggedIn = false;
  final List<Subreddit> recentlyVisited = [];


  UserModel(this.username);

  void updateUserStatus(bool status) {
    isLoggedIn = status;
  }

  void setrecentlyVisited(Subreddit communityName) {
    recentlyVisited.add(communityName);
  }

  List<Subreddit> getrecentlyvisited(){
    return recentlyVisited;
  }
}
