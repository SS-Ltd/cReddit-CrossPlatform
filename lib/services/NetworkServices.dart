import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/savedcomments.dart';
import 'package:reddit_clone/models/subreddit.dart';
import 'dart:convert';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/user_settings.dart';
import 'package:reddit_clone/models/joined_communities.dart';
import 'package:reddit_clone/models/comments.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:path/path.dart';

class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  NetworkService._internal();
  //final String _baseUrl = 'http://192.168.1.7:3000';
  final String _baseUrl = 'https://creddit.tech/API';
  String _cookie = '';
  UserModel? _user;
  UserModel? get user => _user;
  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;

  Future<bool> login(String username, String password) async {
    print('Logging in...');
    Uri url = Uri.parse('$_baseUrl/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      _updateCookie(response);
      var data = jsonDecode(response.body);
      _user = UserModel.fromJson(data);
      _user!.updateUserStatus(true);
      print('Logged in. Cookie: $_cookie');
      notifyListeners();
      return true;
    } else {
      print('Login failed: ${response.body}');
    }
    notifyListeners();
    return false;
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

  getUser() {
    return _user;
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
    if (response.statusCode == 403) {
      refreshToken();
      return getUserSettings();
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      _userSettings = UserSettings.fromJson(json);
      notifyListeners(); // Notify listeners to update UI or other components listening to changes
    } else {
      print('Failed to fetch user settings: ${response.body}');
    }
  }

  /*
    Uri url = Uri.parse('$_baseUrl/comment');

    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.headers.addAll(_headers);

    request.fields['postId'] = postId;
    request.fields['content'] = content;

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
  */

  Future<void> updateUserSettings(String newName) async {
    Uri url = Uri.parse('$_baseUrl/user/settings');

    http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.headers.addAll(_headers);

    Map<String, dynamic> json = {
      'displayName': newName,
    };
    request.fields['profile'] = jsonEncode(json);
    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
  }

  Future<bool> forgotPassword(String username) async {
    final url = Uri.parse('$_baseUrl/user/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'info': username}),
    );
    if (response.statusCode == 403) {
      refreshToken();
      return forgotPassword(username);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> upVote(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/upvote');
    final response = await http.patch(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return upVote(postId);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> downVote(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/downvote');
    final response = await http.patch(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return downVote(postId);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getRandomName() async {
    Uri url = Uri.parse('$_baseUrl/user/generate-username');
    final response = await http.get(url);
    if (response.statusCode == 403) {
      refreshToken();
      return getRandomName();
    }
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
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 403) {
      refreshToken();
      return createUser(username, email, password, gender);
    }
    if (response.statusCode == 201) {
      _updateCookie(response);
      var data = jsonDecode(response.body);
      _user = UserModel.fromJson(data);
      _user!.updateUserStatus(true);
      print('Logged in. Cookie: $_cookie');
      notifyListeners();
      return true;
    } else {
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
    if (response.statusCode == 403) {
      refreshToken();
      return fetchTopCommunities();
    }
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(
          response.body); // change List<dynamic> to Map<String, dynamic>
      final List<dynamic> communities = jsonData[
          'topCommunities']; // replace 'communities' with the actual key in the JSON response
      return communities.map((item) => Community.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch top communities');
    }
  }

  Future<List<Comments>?> fetchCommentsForPost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/comments');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchCommentsForPost(postId);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((commentJson) => Comments.fromJson(commentJson))
          .toList();
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> createNewTextComment(
      String postId, String content) async {
    Uri url = Uri.parse('$_baseUrl/comment');

    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.headers.addAll(_headers);

    request.fields['postId'] = postId;
    request.fields['content'] = content;

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
    if (response.statusCode == 403) {
      refreshToken();
      return createNewTextComment(postId, content);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      var parsedJson = jsonDecode(responseBody);
      if (parsedJson['commentId'] != null) {
        String commentId = parsedJson['commentId'];
        return {'success': true, 'commentId': commentId, 'user': _user};
      } else {
        return {'success': false, 'user': _user};
      }
    } else {
      return {'success': false, 'user': _user};
    }
  }

  Future<Map<String, dynamic>> createNewImageComment(
      String postId, File imageFile) async {
    Uri url = Uri.parse('$_baseUrl/comment');

    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.headers.addAll(_headers);

    request.fields['postId'] = postId;

    request.files.add(await http.MultipartFile.fromPath(
      'images',
      imageFile.path,
      filename: basename(imageFile.path),
    ));

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
    if (response.statusCode == 403) {
      refreshToken();
      return createNewImageComment(postId, imageFile);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      var parsedJson = jsonDecode(responseBody);
      if (parsedJson['commentId'] != null) {
        String commentId = parsedJson['commentId'];
        return {'success': true, 'commentId': commentId, 'user': _user};
      } else {
        return {'success': false, 'user': _user};
      }
    } else {
      return {'success': false, 'user': _user};
    }
  }

  Future<bool> editTextComment(String commentId, String content) async {
    Uri url = Uri.parse('$_baseUrl/comment/$commentId');

    http.MultipartRequest request = http.MultipartRequest('PATCH', url);

    request.headers.addAll(_headers);

    request.fields['content'] = content;

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    if (response.statusCode == 403) {
      refreshToken();
      return editTextComment(commentId, content);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editImageComment(String commentId, File imageFile) async {
    Uri url = Uri.parse('$_baseUrl/comment/$commentId');

    http.MultipartRequest request = http.MultipartRequest('PATCH', url);

    request.headers.addAll(_headers);

    request.files.add(await http.MultipartFile.fromPath(
      'images',
      imageFile.path,
      filename: basename(imageFile.path),
    ));

    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    if (response.statusCode == 403) {
      refreshToken();
      return editImageComment(commentId, imageFile);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> joinSubReddit(String subredditName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$subredditName/join');
    final response = await http.post(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return joinSubReddit(subredditName);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> disJoinSubReddit(String subredditName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$subredditName/join');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return disJoinSubReddit(subredditName);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveOrUnsaveComment(String commentId, bool isSaved) async {
    Uri url = Uri.parse('$_baseUrl/post/$commentId/save');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isSaved': isSaved}));
    if (response.statusCode == 403) {
      refreshToken();
      return saveOrUnsaveComment(commentId, isSaved);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    Uri url = Uri.parse('$_baseUrl/comment/$commentId');
    final response = await http.delete(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return deleteComment(commentId);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> blockUser(String username) async {
    Uri url = Uri.parse('$_baseUrl/user/block/$username');
    final response = await http.post(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return blockUser(username);
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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
    if (response.statusCode == 403) {
      refreshToken();
      return createCommunity(name, isNSFW);
    }
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isSubredditNameAvailable(String name) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/is-name-available/$name');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return isSubredditNameAvailable(name);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['available'] ?? false;
    } else {
      // Handle error or assume name is not available
      return false;
    }
  }

  Future<Subreddit?> getSubredditDetails(String? subredditName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$subredditName');
    final response = await http.get(url, headers: _headers);
    print("SUBREDDITDETAILS");
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return getSubredditDetails(subredditName);
    }
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Subreddit.fromJson(json);
    } else {
      return null;
    }
  }

  Future<UserModel> getUserDetails(String username) async {
    Uri url = Uri.parse('$_baseUrl/user/$username');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      getUserDetails(username);
    }
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  Future<UserModel> getMyDetails() async {
    Uri url = Uri.parse('$_baseUrl/user');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      getMyDetails();
    }
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }

  Future<List<PostModel>?> fetchHomeFeed({
    String sort = 'hot',
    String time = 'all',
    int page = 1,
    int limit = 5,
  }) async {
    final url = Uri.parse('$_baseUrl/post/home-feed?'
        'sort=$sort'
        '&time=$time'
        '&page=$page'
        '&limit=$limit');

    final response =
        await http.get(url, headers: {'accept': 'application/json'});
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchHomeFeed(sort: sort, time: time, page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<PostModel> posts = responseData
          .map<PostModel>((postJson) => PostModel.fromJson(postJson))
          .toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> fetchUserPosts(
    String username, {
    String sort = 'hot',
    String time = 'all',
    int page = 1,
    int limit = 5,
  }) async {
    final url = Uri.parse('$_baseUrl/user/$username/posts?'
        'sort=$sort'
        '&time=$time'
        '&page=$page'
        '&limit=$limit');

    final response =
        await http.get(url, headers: {'accept': 'application/json'});

    if (response.statusCode == 403) {
      refreshToken();
      return fetchUserPosts(username,
          sort: sort, time: time, page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<PostModel> posts = responseData
          .map<PostModel>((postJson) => PostModel.fromJson(postJson))
          .toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> fetchPostsForSubreddit(String? subredditName,
      {int page = 1, int limit = 10, String sort = 'hot'}) async {
    Uri url = Uri.parse(
        '$_baseUrl/subreddit/$subredditName/posts?page=$page&limit=$limit&sort=$sort');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchPostsForSubreddit(subredditName,
          page: page, limit: limit, sort: sort);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((postJson) => PostModel.fromJson(postJson))
          .toList();
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getSavedPosts({int page = 1, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/user/saved-posts?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return getSavedPosts(page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PostModel> posts =
          jsonData.map((item) => PostModel.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getUserHistory(
      {int page = 1, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/user/history?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return getUserHistory(page: page, limit: limit);
    }
    if (response.statusCode == 403) {
      refreshToken();
      return getUserHistory(page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PostModel> posts =
          jsonData.map((item) => PostModel.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getUpvotedPosts(
      {int page = 1, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/user/upvoted?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return getUpvotedPosts(page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PostModel> posts =
          jsonData.map((item) => PostModel.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getDownvotedPosts(
      {int page = 1, int limit = 10}) async {
    final url = Uri.parse('$_baseUrl/user/downvoted?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return getDownvotedPosts(page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<PostModel> posts =
          jsonData.map((item) => PostModel.fromJson(item)).toList();
      return posts;
    } else {
      return null;
    }
  }

  Future<List<PostModel>?> getHiddenPosts(
      {int page = 1, int limit = 10}) async {
    final url =
        Uri.parse('$_baseUrl/user/hidden-posts?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return getHiddenPosts(page: page, limit: limit);
    }
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
        'communityName': communityname,
        'title': title,
        'content': content,
        'isSpoiler': isSpoiler,
        'isNSFW': isNSFW,
      }),
    );
    if (response.statusCode == 403) {
      refreshToken();
      return createNewTextOrLinkPost(
          type, communityname, title, content, isNSFW, isSpoiler);
    }
    if (response.statusCode == 201) {
      return true;
    } else {
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
    if (response.statusCode == 403) {
      refreshToken();
      return createNewImagePost(
          communityname, title, content, isNSFW, isSpoiler);
    }
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
        'content': content,
        'pollOptions': options,
        'expirationDate': expDate,
        'isSpoiler': isSpoiler,
        'isNSFW': isNSFW,
      }),
    );
    if (response.statusCode == 403) {
      refreshToken();
      return createNewPollPost(
          communityname, title, content, options, expDate, isNSFW, isSpoiler);
    }
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
    if (response.statusCode == 403) {
      refreshToken();
      return joinedcommunitites();
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<JoinedCommunitites> joinedCommunitites = responseData
          .map((item) => JoinedCommunitites.fromJson(item))
          .toList();
      return joinedCommunitites;
    } else {
      return null;
    }
  }

  Future<bool> voteOnPoll(String postId, String pollOption) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/vote-poll');
    final response = await http.patch(
      url,
      headers: _headers,
      body: jsonEncode({'pollOption': pollOption}),
    );
    if (response.statusCode == 403) {
      refreshToken();
      return voteOnPoll(postId, pollOption);
    }
    if (response.statusCode == 200) {
      return true; // Voting was successful
    } else {
      return false; // Voting failed
    }
  }

  Future<bool> deletepost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return deletepost(postId);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveandunsavepost(String postId, bool value) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/save');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isSaved': value}));
    if (response.statusCode == 403) {
      refreshToken();
      return saveandunsavepost(postId, value);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> lockpost(String postId, bool value) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/lock');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isLocked': value}));
    if (response.statusCode == 403) {
      refreshToken();
      return lockpost(postId, value);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hidepost(String postId, bool value) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/hide');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isHidden': value}));
    if (response.statusCode == 403) {
      refreshToken();
      return hidepost(postId, value);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Comments>?> fetchSavedComments(
      {int page = 1, int limit = 20}) async {
    Uri url =
        Uri.parse('$_baseUrl/user/saved-comments?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchSavedComments(page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((commentJson) => Comments.fromJson(commentJson))
          .toList();
    } else {
      // Handle error or empty case appropriately
      return null;
    }
  }

  Future<List<Comments>?> fetchUserComments(String username,
      {int page = 1, int limit = 20}) async {
    Uri url =
        Uri.parse('$_baseUrl/user/$username/comments?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchUserComments(username, page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((commentJson) => Comments.fromJson(commentJson))
          .toList();
    } else {
      // Handle error or empty case appropriately
      return null;
    }
  }

//////////////////////////////////////////check
  Future<bool> followpost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/follow');
    final response = await http.patch(url, headers: _headers);
    print(response);
    if (response.statusCode == 403) {
      refreshToken();
      return followpost(postId);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> reportPost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/report');
    final response = await http.post(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return reportPost(postId);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> updatepassword(
      String newPassword, String confirmPassword, String oldPassword) async {
    Uri url = Uri.parse('$_baseUrl/user/change-password');
    final response = await http.patch(url,
        headers: _headers,
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword
        }));
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 400) {
      return response.body;
    } else {
      return "";
    }
  }

  Future<String> updateemail(String newemail, String password) async {
    Uri url = Uri.parse('$_baseUrl/user/change-email');
    final response = await http.patch(url,
        headers: _headers,
        body: jsonEncode({'password': password, 'newEmail': newemail}));
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 400) {
      return response.body;
    } else {
      return "";
    }
  }

  Future<String> resetusername(String email) async {
    Uri url = Uri.parse('$_baseUrl/user/forgot-username');
    final response = await http.post(url,
        headers: _headers, body: jsonEncode({'email': email}));
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      return response.body;
    } else {
      return "";
    }
  }

  Future<String> resetpassword(String email, String username) async {
    Uri url = Uri.parse('$_baseUrl/user/forgot-password');
    final response = await http.post(url,
        headers: _headers,
        body: jsonEncode({'username': username, 'email': email}));
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      return response.body;
    } else if (response.statusCode == 500) {
      return response.body;
    } else {
      return "";
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
