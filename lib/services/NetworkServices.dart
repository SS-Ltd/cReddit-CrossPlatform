import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'dart:convert';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/user_settings.dart';
import 'package:reddit_clone/models/joined_communities.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/community.dart';

class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  NetworkService._internal();

  //String _baseUrl = 'http://10.0.2.2:3000';
  String _baseUrl = 'https://creddit.tech/API';
  String _cookie = '';
  UserModel? _user;
  UserModel? get user => _user;
  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;

  Future<void> login(String username, String password) async {
    print('Logging in...');
    Uri url = Uri.parse('$_baseUrl/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    print(response.body);
    if (response.statusCode == 200) {
      _updateCookie(response);
      var data = jsonDecode(response.body);
      _user = UserModel.fromJson(data);
      _user!.updateUserStatus(true);
      print('Logged in. Cookie: $_cookie');
    } else {
      print('Login failed: ${response.body}');
    }
    notifyListeners();
  }

  Future<bool> sendGoogleAccessToken(String googleAccessToken) async {
    Uri url = Uri.parse('$_baseUrl/user/auth/google');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'googleToken': googleAccessToken}),
    );

    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Access token sent successfully');
      _updateCookie(response);
      _user = UserModel.fromJson(jsonDecode(response.body));
      _user!.updateUserStatus(true);
      print('Logged in. Cookie: $_cookie');
      return true;
    } else {
      print('Failed to send access token: ${response.body}');
    }
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    Uri url = Uri.parse('$_baseUrl/user/logout');
    final response = await http.get(url, headers: _headers);
    print('Logged out: ${response.body}');
  }

  Future<void> getUserSettings() async {
    Uri url = Uri.parse('$_baseUrl/user/settings');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      _userSettings = UserSettings.fromJson(json);
      notifyListeners(); // Notify listeners to update UI or other components listening to changes
    } else {
      print('Failed to fetch user settings: ${response.body}');
    }
  }

  Future<bool> forgotPassword(String username) async {
    final url = Uri.parse('$_baseUrl/user/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'info': username}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> postUpVote(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/upvote');
    final response = await http.patch(url,headers: _headers);
    print (response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

    Future<bool> postDownVote(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/downvote');
    final response = await http.patch(url,headers: _headers);
    print (response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getRandomName() async {
    Uri url = Uri.parse('$_baseUrl/user/generate-username');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['username'];
    } else {
      throw Exception('Failed to get random name');
    }
  }

  Future<bool> createUser(
      String username, String email, String password, String gender) async {
    final url = Uri.parse('$_baseUrl/user');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'gender': gender,
      }),
    );

    if (response.statusCode == 201) {
      print(response);
      return true;
    } else {
      print('Failed to create user: ${response.body}');
      return false;
    }
  }

  Future<void> refreshToken() async {
    Uri url = Uri.parse('$_baseUrl/user/refresh-token');

    // Extract refreshToken from _headers['Cookie']
    String? rawCookie = _headers['Cookie'];
    String refreshToken = '';
    if (rawCookie != null) {
      refreshToken = rawCookie.split(',').firstWhere(
          (element) => element.contains('refreshToken'),
          orElse: () => '');
    }

    final response = await http.get(url, headers: {'Cookie': refreshToken});
    print("alo?");
    print(_headers['Cookie']);
    if (response.statusCode == 200) {
      _updateCookie(response);
      print('Token refreshed successfully. New Cookie: $_cookie');
    } else {
      print('Failed to refresh token: ${response.body}');
    }
  }

  Future<List<Community>> fetchTopCommunities() async {
    Uri url = Uri.parse('$_baseUrl/subreddit/top?limit=25');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => Community.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch top communities');
    }
  }

  Future<List<Comments>?> fetchCommentsForPost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/comments');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((commentJson) => Comments.fromJson(commentJson))
          .toList();
    }
  }

  Future<bool> createCommunity(String name, bool isNSFW) async {
    Uri url = Uri.parse('$_baseUrl/subreddit');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'isNSFW': isNSFW,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create community: ${response.body}');
      return false;
    }
  }

  Future<bool> isSubredditNameAvailable(String name) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/is-name-available/$name');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['available'] ?? false;
    } else {
      // Handle error or assume name is not available
      return false;
    }
  }

  Future<Subreddit?> getSubredditDetails(String subredditName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$subredditName');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Subreddit.fromJson(json);
    } else {
      // Failed to fetch details or handle specific error
      return null;
    }
  }

  Future<List<PostModel>?> fetchPostsForSubreddit(String subredditName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$subredditName/posts');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((postJson) => PostModel.fromJson(postJson))
          .toList();
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getSavedPosts() async {
    final url = Uri.parse('$_baseUrl/user/saved');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PostModel> posts =
          jsonData.map((item) => PostModel.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getUserHistory() async {
    final url = Uri.parse('$_baseUrl/user/history');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PostModel> posts =
          jsonData.map((item) => PostModel.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<bool> createNewTextOrLinkPost(String type, String communityname,
      String title, String content, bool isNSFW, bool isSpoiler) async {
    Uri url = Uri.parse('$_baseUrl/post');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'type': type,
        'communityname': communityname,
        'title': title,
        'content': content,
        'isNSFW': isNSFW,
        'isSpoiler': isSpoiler,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create post: ${response.body}');
      return false;
    }
  }

  Future<bool> createNewImagePost(String communityname, String title,
      String content, bool isNSFW, bool isSpoiler) async {
    Uri url = Uri.parse('$_baseUrl/post');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'type': 'Images & Video',
        'communityname': communityname,
        'title': title,
        //'images' :
        'isSpoiler': isSpoiler,
        'isNSFW': isNSFW,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create post: ${response.body}');
      return false;
    }
  }

  Future<bool> createNewPollPost(
      String communityname,
      String title,
      String content,
      List<String> options,
      String expDate,
      bool isNSFW,
      bool isSpoiler) async {
    Uri url = Uri.parse('$_baseUrl/post');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'type': 'Poll',
        'communityname': communityname,
        'title': title,
        //'content' :
        //'pollOptions' :
        //'expirationDate' :
        'isSpoiler': isSpoiler,
        'isNSFW': isNSFW,
      }),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create post: ${response.body}');
      return false;
    }
  }

  Future<List<JoinedCommunitites>?> joinedcommunitites() async {
    Uri url = Uri.parse('$_baseUrl/user/joined-communities');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List<dynamic> responseData = json.decode(response.body);
      List<JoinedCommunitites> joinedCommunitites = responseData
          .map((item) => JoinedCommunitites.fromJson(item))
          .toList();
      return joinedCommunitites;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getHomeFeed() async {
    Uri url = Uri.parse('$_baseUrl/post/home-feed?limit=25');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((postJson) => PostModel.fromJson(postJson))
          .toList();
    } else {
      return null;
    }
  }

  void _updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _cookie = rawCookie;
    }
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_cookie.isNotEmpty) 'Cookie': _cookie,
      };
}
