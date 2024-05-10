import 'package:reddit_clone/models/chat.dart';
import 'package:reddit_clone/models/chatmessage.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/notification.dart';
import 'package:reddit_clone/models/post_model.dart';
// import the comments
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';

class MockNetworkService extends NetworkService {
  MockNetworkService() : super.instance();
  bool isLoginCalled = false;
  bool loginResult = false;

  @override
  Future<bool> joinSubReddit(String subredditName) async {
    return true;
  }

  @override
  Future<bool> disJoinSubReddit(String subredditName) async {
    return true;
  }

  @override
  Future<List<PostModel>?> fetchPostsForSubreddit(String? subredditName,
      {int page = 1, int limit = 10, String sort = 'hot'}) async {
    return [
      PostModel(
        title: 'Test Post',
        content: 'Hello there!',
        postId: '',
        type: 'Post',
        username: 'username',
        communityName: 'communityname',
        pollOptions: [],
        expirationDate: null,
        netVote: 0,
        isSpoiler: false,
        isLocked: false,
        isApproved: false,
        isEdited: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        profilePicture: 'assets/hehe.png',
        commentCount: 0,
        isDeletedUser: false,
        isUpvoted: false,
        isDownvoted: false,
        isSaved: false,
        isHidden: false,
        isNSFW: false,
      ),
    ];
  }

  @override
  Future<Subreddit?> getSubredditDetails(String? subredditName) async {
    return Subreddit(
      name: 'Test Subreddit',
      description: 'This is a test subreddit',
      members: 0,
      isMember: false,
      isModerator: false,
      icon: 'assets/hehe.png',
      banner: 'assets/hehe.png',
      rules: [],
      moderators: [],
    );
  }

  @override
  Future<List<Chat>> fetchChats() async {
    return [
      Chat(
        id: '1',
        name: 'Test Chat 1',
        lastSentMessage: Message(
            content: 'Hello',
            isRead: false,
            id: '',
            room: '',
            isDeleted: false,
            reactions: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
        updatedAt: DateTime.now(),
        createdAt: DateTime.now(),
        members: [],
        host: '',
        isDeleted: false,
      ),
    ];
  }

  @override
  Future<bool> blockUser(String username) async {
    return true;
  }

  @override
  Future<void> markChatAsRead(String chatId) async {
    // Mock implementation, maybe print something or just a simple return
    print('Marking chat as read: $chatId');
  }

  @override
  String getAccessToken() {
    return "mock-access-token";
  }

  @override
  Future<List<ChatMessages>?> fetchChatMessages(String chatId) async {
    return [
      ChatMessages(
        id: "1",
        user: "John Doe",
        room: "Test Room",
        content: "Hello there!",
        profilePicture: 'assets/hehe.png',
        isDeleted: false,
        reactions: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  getUser() {
    return UserModel(
        username: 'mockUser',
        displayName: '',
        email: '',
        profilePicture: '',
        followers: 0,
        cakeDay: DateTime.now(),
        isBlocked: false);
  }

  @override
  Future<int> getUnreadNotifications() async {
    return 5;
  }

  @override
  Future<List<Community>> fetchTopCommunities() async {
    return [
      Community(
        name: 'Annamae.Rohan10',
        icon: 'assets/hehe.png',
        members: 100,
        description:
            'Sunt capio vapulus deorsum ultio comburo validus defessus. Ait caritas utique earum sumptus bibo assentator. Sulum vitae laborum pauper pax aestas ipsum currus nam caute.',
        isJoined: false,
      ),
      Community(
        name: 'Carlotta.Kreiger61',
        icon: 'assets/hehe.png',
        members: 95,
        description:
            'Qui absum aiunt vehemens cernuus cenaculum accendo alveus occaecati bonus. Voluptate arbitro caste celo quaerat concedo. Summa strues vereor spero.',
        isJoined: true,
      ),
      Community(
        name: 'Petra.Hilpert',
        icon: 'assets/hehe.png',
        members: 81,
        description:
            'Laborum alias tabula surculus campana. Porro commodo numquam vulgo surgo undique voluptas. Facilis caste incidunt ventus tergiversatio conculco temperantia adaugeo ipsum taceo.',
        isJoined: false,
      ),
    ];
  }

  Future<bool> login(String username, String password, String? fcmToken) async {
    print('Mock Logging in...');
    isLoginCalled = true;

    // You can add conditions to simulate different responses based on the input
    if (username == 'validUser' && password == 'validPassword') {
      super.updateUser(UserModel(
        username: 'mockUser',
        displayName: '',
        email: '',
        profilePicture: '',
        followers: 0,
        cakeDay: DateTime.now(),
        isBlocked: false,
      ));

      print('Mock Logged in.');
      return loginResult = true;
    } else {
      print('Mock Login failed');
      return loginResult = false;
    }
  }

  bool isSignUpCalled = false;
  bool signUpResult = false;

  Future<bool> signUp(String email, String password) async {
    print('Mock Signing up...');
    isSignUpCalled = true;

    // You can add conditions to simulate different responses based on the input
    if (email == 'validEmail' && password == 'validPassword') {
      print('Mock Signed up.');
      return signUpResult = true;
    } else {
      print('Mock Sign up failed');
      return signUpResult = false;
    }
  }

  Future<List<PostModel>?> fetchUserPosts(
    String username, {
    String sort = 'hot',
    String time = 'all',
    int page = 1,
    int limit = 10,
  }) async {
    return [
      PostModel(
        title: 'User Post',
        content: 'This is a user post',
        postId: '1',
        type: 'Post',
        username: username,
        communityName: 'communityname',
        pollOptions: [],
        expirationDate: null,
        netVote: 0,
        isSpoiler: false,
        isLocked: false,
        isApproved: false,
        isEdited: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        profilePicture: '',
        commentCount: 0,
        isDeletedUser: false,
        isUpvoted: false,
        isDownvoted: false,
        isSaved: false,
        isHidden: false,
        isNSFW: false,
      ),
    ];
  }

  
  Future<List<Comments>?> fetchUserComments(String username,
      {int page = 1, int limit = 10}) async {
    return [
      Comments(
        profilePicture: 'assets/hehe.png',
        username: 'username',
        isImage: false,
        netVote: 0,
        content: 'This is a user comment',
        createdAt: DateTime.now().toString(),
        commentId: '1',
        isUpvoted: false,
        isDownvoted: false,
        isSaved: false,
        communityName: 'communityname',
        postId: '1',
        title: 'Post Title',
        isApproved: false,
      ),
    ];
  }

  Future<bool> approvePost(String postId, bool isApproved) async {
    return true;
  }

  Future<bool> removePost(String postId, bool isRemoved) async {
    return true;
  }

  Future<bool> lockpost(String postId, bool isLocked) async {
    return true;
  }

  Future<bool> markAsSpoiler(String postId, bool isSpoiler) async {
    return true;
  }

  Future<bool> markAsNSFW(String postId, bool isNSFW) async {
    return true;
  }

  @override
  Future<List<Messages>?> fetchInboxMessages({int page = 1, int limit = 10}) async {
    return List<Messages>.generate(limit, (index) {
      return Messages(
        id: 'id$index',
        from: 'from$index', // This should create a message with 'from0' as the 'from' field
        to: 'to$index',
        subject: 'subject$index',
        text: 'text$index',
        isRead: index % 2 == 0,
        isDeleted: index % 2 != 0,
        createdAt: DateTime.now().toString(),
      );
    });
  }

  @override
  Future<List<NotificationModel>?> fetchNotifications() async {
    return List<NotificationModel>.generate(5, (index) {
      return NotificationModel(
        id: 'id1',
        user: 'user1',
        notificationFrom: 'notificationFrom1',
        type: 'type1',
        resourceId: 'resourceId1',
        title: 'title1',
        content: 'content1',
        isRead: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        profilePic: 'assets/hehe.png',
      );
    });
  }
}
