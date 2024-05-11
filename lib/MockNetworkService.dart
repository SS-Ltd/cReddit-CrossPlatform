import 'package:reddit_clone/models/bannedusers.dart';
import 'package:reddit_clone/models/chat.dart';
import 'package:reddit_clone/models/chatmessage.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/notification.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/search.dart';
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
  Future<UserModel> getMyDetails() async {
    return UserModel(
      username: 'username',
      displayName: 'Display Name',
      about: 'About user',
      email: 'user@example.com',
      profilePicture: 'assets/hehe.png',
      banner: 'assets/hehe.png',
      followers: 100,
      cakeDay: DateTime.parse('2022-01-01'),
      isBlocked: false,
    );
  }

  @override
  Future<PostModel> fetchPost(String id) async {
    return PostModel(
      postId: '1',
      type: 'post',
      username: 'username',
      communityName: 'community',
      title: 'Post Title',
      content: 'This is a post',
      pollOptions: [
        PollsOption(
          option: 'Option 1',
          isVoted: false,
          votes: 10,
        ),
      ],
      expirationDate: DateTime.parse('2022-12-31'),
      netVote: 10,
      isSpoiler: false,
      isLocked: false,
      isApproved: true,
      isEdited: false,
      createdAt: DateTime.parse('2022-01-01'),
      updatedAt: DateTime.parse('2022-01-02'),
      profilePicture: 'assets/hehe.png',
      commentCount: 2,
      isDeletedUser: false,
      isUpvoted: false,
      isDownvoted: false,
      isSaved: false,
      isHidden: false,
      isJoined: false,
      isModerator: false,
      isBlocked: false,
      isNSFW: false,
    );
  }

  @override
  Future<BannedUserList?> fetchUnbannedUsers() async {
    return BannedUserList(
      bannedUsers: [
        BannedUser(
          name: 'User1',
          reasonToBan: '',
          days: null,
        ),
        BannedUser(
          name: 'User2',
          reasonToBan: '',
          days: null,
        ),
      ],
    );
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
      rules: ['Spam', 'Harassment'],
      moderators: [],
    );
  }

  @override
  Future<List<Comments>?> fetchSavedComments(
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
  Future<UserModel> getUserDetails(String username) async {
    return UserModel(
        username: 'mockUser',
        displayName: '',
        email: '',
        profilePicture: 'assets/hehe.png',
        followers: 0,
        cakeDay: DateTime.now(),
        isBlocked: false);
  }

  @override
  Future<void> logout(String? fcmToken) async {
    return;
  }

  @override
  getUser() {
    return UserModel(
        username: 'mockUser',
        displayName: '',
        email: '',
        profilePicture: 'assets/hehe.png',
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

  @override
  Future<bool> editTextPost(String postId, String content) async {
    return true;
  }

  @override
  Future<bool> createGroupChatRoom(String name, List<String> members) async {
    return true;
  }

  @override
  Future<String> createPrivateChatRoom(List<String> member) async {
    return '1';
  }

  @override
  Future<List<SearchUsers>> getSearchUsers(String user, int pageNumber) async {
    return [
      SearchUsers(
        id: '1',
        username: 'username',
        about: 'About user',
        profilePicture: 'assets/hehe.png',
        isNSFW: false,
      ),
      SearchUsers(
        username: 'user1',
        profilePicture: 'assets/hehe.png',
      ),
      SearchUsers(
        username: 'user2',
        profilePicture: 'assets/hehe.png',
      ),
    ];
  }

  @override
  Future<List<PostModel>?> getUserHistory(
      {int page = 1, int limit = 10}) async {
    return [
      PostModel(
        title: 'User Post',
        content: 'This is a user post',
        postId: '1',
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
  Future<List<PostModel>?> getUpvotedPosts(
      {int page = 1, int limit = 10}) async {
    return [
      PostModel(
        title: 'User Post',
        content: 'This is a user post',
        postId: '2',
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
        isUpvoted: true,
        isDownvoted: false,
        isSaved: false,
        isHidden: false,
        isNSFW: false,
      ),
    ];
  }

  @override
  Future<List<PostModel>?> getDownvotedPosts(
      {int page = 1, int limit = 10}) async {
    return [
      PostModel(
        title: 'User Post',
        content: 'This is a user post',
        postId: '3',
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
        isDownvoted: true,
        isSaved: false,
        isHidden: false,
        isNSFW: false,
      ),
    ];
  }

  // Future<bool> login(String username, String password, String? fcmToken) async {
  //   print('Mock Logging in...');
  //   isLoginCalled = true;

  //   // You can add conditions to simulate different responses based on the input
  //   if (username == 'validUser' && password == 'validPassword') {
  //     super.updateUser(UserModel(
  //       username: 'mockUser',
  //       displayName: '',
  //       email: '',
  //       profilePicture: '',
  //       followers: 0,
  //       cakeDay: DateTime.now(),
  //       isBlocked: false,
  //     ));

  //     print('Mock Logged in.');
  //     return loginResult = true;
  //   } else {
  //     print('Mock Login failed');
  //     return loginResult = false;
  //   }
  // }

  bool isSignUpCalled = false;
  bool signUpResult = false;

  @override
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

  @override
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

  @override
  Future<bool> approvePost(String postId, bool isApproved) async {
    return true;
  }

  @override
  Future<bool> removePost(String postId, bool isRemoved) async {
    return true;
  }

  @override
  Future<bool> lockpost(String postId, bool value) async {
    return true;
  }

  @override
  Future<bool> markAsSpoiler(String postId, bool isSpoiler) async {
    return true;
  }

  @override
  Future<bool> markAsNSFW(String postId, bool isNSFW) async {
    return true;
  }

  @override
  Future<List<Messages>?> fetchInboxMessages(
      {int page = 1, int limit = 10}) async {
    return List<Messages>.generate(limit, (index) {
      return Messages(
        id: 'id$index',
        from:
            'from$index', // This should create a message with 'from0' as the 'from' field
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

  @override
  Future<int> updateemail(String newemail, String password) async {
    if (newemail != '' && password != '') {
      return 201;
    } else {
      return 401;
    }
  }

  @override
  Future<List<SearchComments>> getSearchComments(
      String comment,
      String username,
      String sort,
      String timeOption,
      int pageNumber,
      String community) async {
    return [
      SearchComments(
        id: '1',
        postID: 'post1',
        postTitle: 'Post Title',
        postUsername: 'username',
        postVotes: 10,
        postPicture: 'assets/hehe.png',
        postCreatedAt: '2022-01-01',
        isPostNSFW: false,
        isPostSpoiler: false,
        username: 'username',
        communityName: 'community',
        commentPicture: 'assets/hehe.png',
        netVote: 5,
        commentCount: 2,
        content: 'This is a comment',
        createdAt: '2022-01-02',
      )
    ];
  }

  @override
  Future<List<dynamic>> getSearchHashtags(
      String hashtag, int pageNumber, String username, String community) async {
    return [
      SearchHashtag(
        id: '1',
        postID: 'post1',
        postTitle: 'Post Title',
        postUsername: 'username',
        postVotes: 10,
        postPicture: 'assets/hehe.png',
        postCreatedAt: DateTime.now(),
        isPostNsfw: false,
        isPostSpoiler: false,
        communityName: 'community',
        createdAt: DateTime.now(),
        username: 'username',
        netVote: 5,
        commentCount: 2,
        commentPicture: 'assets/hehe.png',
        content: 'This is a comment',
      )
    ];
  }

  @override
  Future<List<SearchPosts>> getSearchPosts(String post, String username,
      String sort, String time, int pageNumber, String community) async {
    return [
      SearchPosts(
        id: '1',
        type: 'post',
        username: 'username',
        communityName: 'community',
        profilePicture: 'assets/hehe.png',
        netVote: 10,
        commentCount: 2,
        title: 'Post Title',
        content: 'This is a post',
        createdAt: '2022-01-01',
        isNSFW: false,
        isSpoiler: false,
      )
    ];
  }

  @override
  Future<List<SearchCommunities>> getSearchCommunities(
      String community, bool autocomplete, int pageNumber) async {
    return [
      SearchCommunities(
        id: '1',
        name: 'Community Name',
        description: 'About community',
        icon: 'assets/hehe.png',
        isNSFW: false,
        members: 100,
      )
    ];
  }

  @override
  Future<bool> muteCommunity(String communityName) async {
    return true;
  }

  @override
  Future<bool> unmuteCommunity(String communityName) async {
    return true;
  }

  @override
  Future<bool> createUser(String? username, String? email, String? password,
      String? gender, String? fcmToken) async {
    print('Mock Creating user...');
    return true;
  }

  @override
  Future<String> getRandomName() async {
    return 'randomName';
  }

  @override
  Future<bool> forgotPassword(String username) async {
    return true;
  }

  @override
    Future<void> getUserSettings() async {
}
}
