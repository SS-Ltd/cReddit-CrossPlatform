// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_clone/models/bannedusers.dart';
import 'package:reddit_clone/models/chat.dart';
import 'package:reddit_clone/models/chatmessage.dart';
import 'package:reddit_clone/models/messages.dart';
import 'package:reddit_clone/models/notification.dart';
import 'dart:io';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/rule.dart';
import 'package:reddit_clone/models/search.dart';
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
  final String _baseUrl = 'https://api.creddit.tech';
  //final String _baseUrl = 'http://192.168.1.10:3000';
  // final String _baseUrl = 'http://192.168.1.10:3000';
  String _cookie = '';
  UserModel? _user;
  UserModel? get user => _user;
  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;

  Future<bool> login(String username, String password, String? fcmToken) async {
    print('Logging in...');
    Uri url = Uri.parse('$_baseUrl/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'username': username, 'password': password, 'fcmToken': fcmToken}),
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

  Future<bool> sendGoogleAccessToken(
      String googleAccessToken, String? fcmToken) async {
    Uri url = Uri.parse('$_baseUrl/user/auth/google');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body:
          jsonEncode({'googleToken': googleAccessToken, 'fcmToken': fcmToken}),
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

  Future<void> logout(String? fcmToken) async {
    Uri url = Uri.parse('$_baseUrl/user/logout');
    final response = await http.post(url,
        headers: _headers, body: jsonEncode({'fcmToken': fcmToken}));
    _cookie = '';
    _user = null;
    print('Logged out: ${response.body}');
  }

  Future<void> getUserSettings() async {
    Uri url = Uri.parse('$_baseUrl/user/settings');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return getUserSettings();
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      _userSettings = UserSettings.fromJson(json);
      notifyListeners();
      // Notify listeners to update UI or other components listening to changes
    }
  }

  Future<bool> updateNotificationsSettings(
      String parameter, bool newValue) async {
    Uri url = Uri.parse('$_baseUrl/user/settings');
    http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.headers.addAll(_headers);
    String jsonString = jsonEncode({parameter: newValue});
    print(jsonString);
    request.fields['notifications'] = jsonString;
    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print(responseBody);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateEmailSettings(String parameter, bool newValue) async {
    Uri url = Uri.parse('$_baseUrl/user/settings');
    http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.headers.addAll(_headers);
    String jsonString = jsonEncode({parameter: newValue});
    print(jsonString);
    request.fields['email'] = jsonString;
    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print(responseBody);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfileSettings(String parameter, bool newValue) async {
    Uri url = Uri.parse('$_baseUrl/user/settings');

    http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.headers.addAll(_headers);

    String jsonString = jsonEncode({parameter: newValue});
    request.fields['profile'] = jsonString;
    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateAllProfileSettings(String displayName, String about,
      File? banner, File? profilePicture) async {
    Uri url = Uri.parse('$_baseUrl/user/settings');
    http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.headers.addAll(_headers);

    String jsonString =
        jsonEncode({'displayName': displayName, 'about': about});
    request.fields['profile'] = jsonString;
    if (banner != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        banner.path,
        filename: basename(banner.path),
      ));
    }
    if (profilePicture != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'avatar',
        profilePicture.path,
        filename: basename(profilePicture.path),
      ));
    }
    http.StreamedResponse response = await request.send();

    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateAccountSettings(String parameter, String newValue) async {
    Uri url = Uri.parse('$_baseUrl/user/settings');

    http.MultipartRequest request = http.MultipartRequest('PUT', url);
    request.headers.addAll(_headers);

    String jsonString = jsonEncode({parameter: newValue});
    request.fields['account'] = jsonString;
    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
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

  Future<bool> createUser(String username, String email, String password,
      String gender, String? fcmToken) async {
    final url = Uri.parse('$_baseUrl/user');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'gender': gender,
        'fcmToken': fcmToken
      }),
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 403) {
      refreshToken();
      return createUser(username, email, password, gender, fcmToken);
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
    if (response.statusCode == 200) {
      _updateCookie(response);
    }
  }

  Future<List<Community>> fetchTopCommunities() async {
    Uri url = Uri.parse('$_baseUrl/subreddit/top?limit=25');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchTopCommunities();
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(
          response.body); // change List<dynamic> to Map<String, dynamic>
      final List<dynamic> communities = jsonData['topCommunities'];
      // replace 'communities' with the actual key in the JSON response
      return communities.map((item) => Community.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch top communities');
    }
  }

  Future<Comments?> fetchCommentById(String commentId) async {
    Uri url = Uri.parse('$_baseUrl/comment/$commentId');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchCommentById(commentId);
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Comments.fromJson(responseData);
    } else {
      return null;
    }
  }

  Future<int> getUnreadNotifications() async {
    Uri url = Uri.parse('$_baseUrl/notification/unread-count');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return getUnreadNotifications();
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData['total'];
    } else {
      return 0;
    }
  }

  Future<List<Comments>?> fetchCommentsForPost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/comments');
    final response = await http.get(url, headers: _headers);
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

  Future<bool> editTextPost(String postId, String content) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId');

    http.MultipartRequest request = http.MultipartRequest('PATCH', url);

    request.headers.addAll(_headers);

    request.fields['content'] = content;

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 403) {
      refreshToken();
      return editTextPost(postId, content);
    }
    if (response.statusCode == 200) {
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

  Future<bool> muteCommunity(String communityName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$communityName/mute');
    final response = await http.post(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return muteCommunity(communityName);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unmuteCommunity(String communityName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$communityName/mute');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return unmuteCommunity(communityName);
    }
    if (response.statusCode == 200) {
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
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return blockUser(username);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unBlockUser(String username) async {
    Uri url = Uri.parse('$_baseUrl/user/block/$username');
    final response = await http.delete(url, headers: _headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return blockUser(username);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser() async {
    Uri url = Uri.parse('$_baseUrl/user');
    final response = await http.delete(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return deleteUser();
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Messages>?> fetchInboxMessages(
      {int page = 1, int limit = 10}) async {
    Uri url = Uri.parse('$_baseUrl/message/?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchInboxMessages(page: page, limit: limit);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<Messages>? inboxMessages =
          responseData.map((item) => Messages.fromJson(item)).toList();
      return inboxMessages;
    } else {
      return null;
    }
  }

  Future<bool> markMessageAsRead(String messageId) async {
    Uri url = Uri.parse('$_baseUrl/message/$messageId/mark-as-read');
    final response = await http.patch(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return markMessageAsRead(messageId);
    }
    print(messageId);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> markAllMessagesasRead() async {
    Uri url = Uri.parse('$_baseUrl/message/mark-all-as-read');
    final response = await http.put(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return markAllMessagesasRead();
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> sendMessege(
      String to, String subject, String message) async {
    Uri url = Uri.parse('$_baseUrl/message/');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'to': to,
        'subject': subject,
        'text': message,
      }),
    );
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return sendMessege(to, subject, message);
    }

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody['messageID']);
      return {
        'success': true,
        'messageID': responseBody['messageID'],
      };
    } else {
      return {
        'success': false,
      };
    }
  }

  Future<bool> createCommunity(String name, bool isNSFW, String type) async {
    Uri url = Uri.parse('$_baseUrl/subreddit');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'isNSFW': isNSFW,
        'type': type.toLowerCase(),
      }),
    );
    print("name: $name, isNSFW: $isNSFW, type: $type");
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return createCommunity(name, isNSFW, type);
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
    if (response.statusCode == 403) {
      refreshToken();
      return getSubredditDetails(subredditName);
    }
    print("hheeiei");
    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Subreddit.fromJson(json);
    }
    if (response.statusCode == 401) {
      return Subreddit(
          name: '',
          icon: '',
          banner: '',
          members: 0,
          rules: [],
          moderators: [],
          description: '',
          isNSFW: false,
          isModerator: false);
    } else {
      return null;
    }
  }

  Future<List<SubredditRule>?> getSubredditRules(String subredditName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$subredditName/rules');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 403) {
      refreshToken();
      return getSubredditRules(subredditName);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<SubredditRule> rules =
          responseData.map((item) => SubredditRule.fromJson(item)).toList();
      return rules;
    } else {
      return null;
    }
  }

  Future<bool> addModerator(String username, String communityName) async {
    Uri url = Uri.parse('$_baseUrl/mod/invite/$communityName');
    final response = await http.post(url,
        headers: _headers, body: jsonEncode({'username': username}));
    if (response.statusCode == 403) {
      refreshToken();
      return addModerator(username, communityName);
    }

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> leaveModerator() async {
    Uri url = Uri.parse('$_baseUrl/mod/leave');
    final response = await http.patch(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return leaveModerator();
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeModerator(String username) async {
    Uri url = Uri.parse('$_baseUrl/mod/leave/$username');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'username': username}));
    if (response.statusCode == 403) {
      refreshToken();
      return removeModerator(username);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<UserModel> getUserDetails(String username) async {
    Uri url = Uri.parse('$_baseUrl/user/$username');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 403) {
      refreshToken();
      getUserDetails(username);
    }
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      print('Failed to fetch user details');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch user details');
    }
  }

  Future<List<SearchComments>> getSearchComments(
      String comment,
      String username,
      String sort,
      String timeOption,
      int pageNumber,
      String community) async {
    sort = sort.toLowerCase();
    timeOption = timeOption.toLowerCase();
    final parameters = {
      'query': comment,
      'user': username,
      'sort': sort,
      'time': timeOption,
      'page': pageNumber.toString(),
      'community': community
    };
    Uri url = Uri.parse('$_baseUrl/search/comments')
        .replace(queryParameters: parameters);
    print(parameters);
    final response = await http.get(url, headers: _headers);
    print(response.statusCode);
    if (response.statusCode == 403) {
      refreshToken();
      return getSearchComments(
          comment, username, sort, timeOption, pageNumber, community);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<SearchComments> searchResult =
          responseData.map((item) => SearchComments.fromJson(item)).toList();
      return searchResult;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getSearchHashtags(
      String hashtag, int pageNumber, String username, String community) async {
    final parameters = {
      'query': hashtag,
      'page': pageNumber.toString(),
      'user': username,
      'community': community
    };
    Uri url = Uri.parse('$_baseUrl/search/hashtags')
        .replace(queryParameters: parameters);

    final response = await http.get(url, headers: _headers);
    print(response.statusCode);
    if (response.statusCode == 403) {
      refreshToken();
      return getSearchHashtags(hashtag, pageNumber, username, community);
    }
    print(response.body);
    print("I am here");
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<dynamic> searchResult = responseData.map((item) {
        switch (item['type']) {
          case 'Post':
            return SearchHashTagPost.fromJson(item);
          case 'Comment':
            return SearchComments.fromJson(item);
          default:
            return SearchHashtag.fromJson(item);
        }
      }).toList();
      print("---------------------------------");
      print(searchResult);
      return searchResult;
    } else {
      return [];
    }
  }

  Future<List<SearchPosts>> getSearchPosts(String post, String username,
      String sort, String time, int pageNumber, String community) async {
    sort = sort.toLowerCase();
    time = time.toLowerCase();
    final parameters = {
      'query': post,
      'user': username,
      'sort': sort,
      'time': time,
      'page': pageNumber.toString(),
      'community': community
    };
    Uri url = Uri.parse('$_baseUrl/search/posts')
        .replace(queryParameters: parameters);

    final response = await http.get(url, headers: _headers);
    print(response.statusCode);
    if (response.statusCode == 403) {
      refreshToken();
      return getSearchPosts(post, username, sort, time, pageNumber, community);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<SearchPosts> searchResult =
          responseData.map((item) => SearchPosts.fromJson(item)).toList();
      return searchResult;
    } else {
      return [];
    }
  }

  Future<List<SearchCommunities>> getSearchCommunities(
      String community, bool autocomplete, int pageNumber) async {
    final parameters = {
      'query': community,
      'autocomplete': autocomplete.toString(),
      'page': pageNumber.toString()
    };
    Uri url = Uri.parse('$_baseUrl/search/communities')
        .replace(queryParameters: parameters);

    final response = await http.get(url, headers: _headers);
    print(response.statusCode);
    if (response.statusCode == 403) {
      refreshToken();
      return getSearchCommunities(community, autocomplete, pageNumber);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<SearchCommunities> searchResult =
          responseData.map((item) => SearchCommunities.fromJson(item)).toList();
      return searchResult;
    } else {
      return [];
    }
  }

  Future<List<SearchUsers>> getSearchUsers(String user, int pageNumber) async {
    final parameters = {'query': user};
    Uri url = Uri.parse('$_baseUrl/search/users')
        .replace(queryParameters: parameters);

    final response = await http.get(url, headers: _headers);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return getSearchUsers(user, pageNumber);
    }
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      List<SearchUsers> searchResult =
          responseData.map((item) => SearchUsers.fromJson(item)).toList();
      return searchResult;
    } else {
      return [];
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
    String sort = 'best',
    String time = 'all',
    int page = 1,
    int limit = 5,
  }) async {
    final url = Uri.parse('$_baseUrl/post/home-feed?'
        'sort=$sort'
        '&time=$time'
        '&page=$page'
        '&limit=$limit');

    final response = await http.get(url, headers: _headers);
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

  Future<PostModel> fetchPost(String id) async {
    final url = Uri.parse('$_baseUrl/post/$id');
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, then parse the JSON.
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load post');
    }
  }

  Future<List<PostModel>?> fetchUserPosts(
    String username, {
    String sort = 'hot',
    String time = 'all',
    int page = 1,
    int limit = 10,
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

  Future<bool> createCrossPost(String postID, String title) async {
    Uri url = Uri.parse('$_baseUrl/post');
    final response = await http.post(url,
        headers: _headers,
        body: jsonEncode(
            {'postId': postID, 'type': 'Cross Post', 'title': title}));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return createCrossPost(postID, title);
    }
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> createNewTextOrLinkPost(
      String type,
      String communityname,
      String title,
      String content,
      bool isNSFW,
      bool isSpoiler,
      bool isLink,
      String? date) async {
    Uri url = Uri.parse('$_baseUrl/post');
    print("klam");
    print(date);
    if (isLink) {
      content = "http://$content";
    }
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
        if (date != null) 'date': date
      }),
    );
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return createNewTextOrLinkPost(
          type, communityname, title, content, isNSFW, isSpoiler, isLink, date);
    }

    var parsedJson = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (parsedJson['postId'] != null) {
        String postId = parsedJson['postId'];
        return {'success': true, 'postId': postId};
      } else {
        return {'success': false};
      }
    } else {
      return {'success': false, 'message': parsedJson['message']};
    }
  }

  Future<Map<String, dynamic>> createNewImagePost(
      String communityname,
      String title,
      File imageFile,
      bool isNSFW,
      bool isSpoiler,
      String? date) async {
    Uri url = Uri.parse('$_baseUrl/post');
    print("wslt");
    http.MultipartRequest request = http.MultipartRequest('POST', url);

    request.headers.addAll(_headers);

    request.fields['type'] = 'Images & Video';
    request.fields['communityName'] = communityname;
    request.fields['title'] = title;
    request.fields['isSpoiler'] = isSpoiler.toString();
    request.fields['isNSFW'] = isNSFW.toString();
    if (date != null) {
      request.fields['date'] = date;
    }
    request.files.add(await http.MultipartFile.fromPath(
      'images',
      imageFile.path,
      filename: basename(imageFile.path),
    ));

    http.StreamedResponse response = await request.send();
    String responseBody = await response.stream.bytesToString();
    print(response.statusCode);
    print(responseBody);
    if (response.statusCode == 403) {
      refreshToken();
      return createNewImagePost(
          communityname, title, imageFile, isNSFW, isSpoiler, date);
    }

    var parsedJson = jsonDecode(responseBody);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (parsedJson['postId'] != null) {
        String postId = parsedJson['postId'];
        return {'success': true, 'postId': postId};
      } else {
        return {'success': false};
      }
    } else {
      return {'success': false, 'message': parsedJson['message']};
    }
  }

  Future<Map<String, dynamic>> createNewPollPost(
      String communityname,
      String title,
      String content,
      List<String> options,
      String expDate,
      bool isNSFW,
      bool isSpoiler,
      String? date) async {
    Uri url = Uri.parse('$_baseUrl/post');
    print(expDate);
    print(date);

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
        if (date != null) 'date': date,
      }),
    );

    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return createNewPollPost(communityname, title, content, options, expDate,
          isNSFW, isSpoiler, date);
    }
    var parsedJson = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (parsedJson['postId'] != null) {
        String postId = parsedJson['postId'];
        return {'success': true, 'postId': postId};
      } else {
        return {'success': false};
      }
    } else {
      return {'success': false, 'message': parsedJson['message']};
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
    print(response.statusCode);
    print(response.body);
    print(response);
    print(postId);
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

  Future<bool> approvePost(String postId, bool isApproved) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/approve');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isApproved': isApproved}));
    if (response.statusCode == 403) {
      refreshToken();
      return approvePost(postId, isApproved);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removePost(String postId, bool isRemoved) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/remove');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isRemoved': isRemoved}));
    if (response.statusCode == 403) {
      refreshToken();
      return removePost(postId, isRemoved);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> markAsSpoiler(String postId, bool isSpoiler) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/mark-spoiler');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isSpoiler': isSpoiler}));
    if (response.statusCode == 403) {
      refreshToken();
      return markAsSpoiler(postId, isSpoiler);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> markAsNSFW(String postId, bool isNSFW) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/mark-nsfw');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isNSFW': isNSFW}));
    if (response.statusCode == 403) {
      refreshToken();
      return markAsNSFW(postId, isNSFW);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> hidepost(String postId, bool value) async {
    print('asdasd');
    Uri url = Uri.parse('$_baseUrl/post/$postId/hide');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isHidden': value}));
    print(response.statusCode);
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
      {int page = 1, int limit = 10}) async {
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
      return null;
    }
  }

  Future<List<Comments>?> fetchUserComments(String username,
      {int page = 1, int limit = 10}) async {
    Uri url =
        Uri.parse('$_baseUrl/user/$username/comments?page=$page&limit=$limit');
    final response = await http.get(url, headers: _headers);
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

  Future<bool> approveComment(String commentId, bool isApproved) async {
    Uri url = Uri.parse('$_baseUrl/post/$commentId/approve');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isApproved': isApproved}));

    if (response.statusCode == 403) {
      refreshToken();
      return approveComment(commentId, isApproved);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeComment(String commentId, bool isRemoved) async {
    Uri url = Uri.parse('$_baseUrl/post/$commentId/remove');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'isRemoved': isRemoved}));

    if (response.statusCode == 403) {
      refreshToken();
      return removeComment(commentId, isRemoved);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

//////////////////////////////////////////check
  Future<bool> followpost(String postId) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/follow');
    final response = await http.patch(url, headers: _headers);
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

  Future<bool> reportPost(String postId, String ruleBroken) async {
    Uri url = Uri.parse('$_baseUrl/post/$postId/report');
    final response = await http.post(url,
        headers: _headers,
        body: jsonEncode({
          'communityRule': ruleBroken,
        }));
    print("REPORT POST HERE:");
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return reportPost(postId, ruleBroken);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> reportComments(String commentId, String ruleBroken) async {
    Uri url = Uri.parse('$_baseUrl/post/$commentId/report');
    final response = await http.post(url,
        headers: _headers,
        body: jsonEncode({
          'communityRule': ruleBroken,
        }));
    print("REPORT COMMENT HERE:");
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return reportPost(commentId, ruleBroken);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> updatepassword(
      String newPassword, String confirmPassword, String oldPassword) async {
    Uri url = Uri.parse('$_baseUrl/user/change-password');
    final response = await http.patch(url,
        headers: _headers,
        body: jsonEncode({
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword
        }));
    return response.statusCode;
  }

  Future<int> updateemail(String newemail, String password) async {
    Uri url = Uri.parse('$_baseUrl/user/change-email');
    final response = await http.patch(url,
        headers: _headers,
        body: jsonEncode({'password': password, 'newEmail': newemail}));
    return response.statusCode;
  }

  Future<int> resetusername(String email) async {
    Uri url = Uri.parse('$_baseUrl/user/forgot-username');
    final response = await http.post(url,
        headers: _headers, body: jsonEncode({'email': email}));
    return response.statusCode;
  }

  Future<int> resetpassword(String email, String username) async {
    Uri url = Uri.parse('$_baseUrl/user/forgot-password');
    final response = await http.post(url,
        headers: _headers,
        body: jsonEncode({'username': username, 'email': email}));
    return response.statusCode;
  }

  Future<bool> markNotificationAsRead(String notificationID) async {
    Uri url = Uri.parse('$_baseUrl/notification/$notificationID/mark-as-read');
    final response = await http.put(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return markNotificationAsRead(notificationID);
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> markChatAsRead(String chatId) async {
    Uri url = Uri.parse('$_baseUrl/chat/$chatId/mark-as-read');
    final response = await http.patch(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return markChatAsRead(chatId);
    }
    print('MARK CHAT AS READ');
    print(response.body);
  }

  Future<bool> markAllNotificationAsRead() async {
    Uri url = Uri.parse('$_baseUrl/notification/mark-all-as-read');
    final response = await http.put(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return markAllNotificationAsRead();
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<NotificationModel>?> fetchNotifications() async {
    Uri url = Uri.parse('$_baseUrl/notification/?limit=100');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchNotifications();
    }
    print("NOTIFICATION EL POST HNA");
    print(response.body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      List<NotificationModel> notifications = responseData['notifications']
          .map<NotificationModel>((item) => NotificationModel.fromJson(item))
          .toList();
      return notifications;
    } else {
      return null;
    }
  }

  Future<List<Chat>?> fetchChats() async {
    Uri url = Uri.parse('$_baseUrl/chat/?page=1&limit=100');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => Chat.fromJson(item)).toList();
    } else {
      return null;
    }
  }

  Future<bool> createGroupChatRoom(String name, List<String> members) async {
    Uri url = Uri.parse('$_baseUrl/chat');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'name': name,
        'members': members,
      }),
    );
    print(response.body);

    if (response.statusCode == 403) {
      refreshToken();
      return createGroupChatRoom(name, members);
    }

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<String> createPrivateChatRoom(List<String> member) async {
    Uri url = Uri.parse('$_baseUrl/chat');
    final response = await http.post(
      url,
      headers: _headers,
      body: jsonEncode({
        'members': member,
      }),
    );
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return createPrivateChatRoom(member);
    }

    var responseBody = jsonDecode(response.body);
    return responseBody['roomID'];
  }

  Future<List<ChatMessages>?> fetchChatMessages(String chatId) async {
    Uri url = Uri.parse('$_baseUrl/chat/$chatId/?page=1&limit=100');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return fetchChatMessages(chatId);
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => ChatMessages.fromJson(item)).toList();
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCommunitySettings(
      String communityName) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$communityName/settings');
    final response = await http.get(url, headers: _headers);
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return getCommunitySettings(communityName);
    }
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      return null;
    }
  }

  // Future<List<Map<String, dynamic>>?> getCommunityRules(String communityName) async {
  //   Uri url = Uri.parse('$_baseUrl/subreddit/$communityName/rules');
  //   final response = await http.get(url, headers: _headers);
  //   print(response.body);
  // if(response.statusCode == 403){
  //     refreshToken();
  //     return getCommunityRules(communityName);
  //   }
  //   if (response.statusCode == 200) {
  //     final List<dynamic> responseData = jsonDecode(response.body);
  //     print(responseData.cast<Map<String, dynamic>>());
  //     return responseData.cast<Map<String, dynamic>>();
  //   } else {
  //     return null;
  //   }
  // }

  Future<bool> updateCommunityRules(
      String communityName, List<Rule> rules) async {
    Uri url = Uri.parse('$_baseUrl/subreddit/$communityName/settings');
    final response = await http.put(url,
        headers: _headers, body: jsonEncode({'rules': rules}));
    print(response.body);
    if (response.statusCode == 403) {
      refreshToken();
      return updateCommunityRules(communityName, rules);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<BannedUserList?> getBannedUsers(String communityName) async {
    Uri url = Uri.parse('$_baseUrl/mod/get-banned-users/$communityName');
    final response = await http.get(url, headers: _headers);

    if (response.statusCode == 403) {
      refreshToken();
      return getBannedUsers(communityName);
    }
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return BannedUserList.fromJson(json);
    } else {
      return null; // i guess this return need to be changed
    }
  }

  Future<bool> banUser(
      String username, String communityName, String rule, int days) async {
    Uri url = Uri.parse('$_baseUrl/mod/ban/$communityName');
    final response = await http.patch(url,
        headers: _headers,
        body: jsonEncode(
            {'username': username,
             'rule': rule,
              if (days != 0) 'days': days
              }));
    if (response.statusCode == 403) {
      refreshToken();
      return banUser(username, communityName, rule, days);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unbanUser(String username, String communityName) async {
    Uri url = Uri.parse('$_baseUrl/mod/unban/$communityName');
    final response = await http.patch(url,
        headers: _headers, body: jsonEncode({'username': username}));
    if (response.statusCode == 403) {
      refreshToken();
      return unbanUser(username, communityName);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
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

  String getAccessToken() {
    String? rawCookie = _headers['Cookie'];
    if (rawCookie != null) {
      var start = rawCookie.indexOf('accessToken=');
      if (start != -1) {
        start += 'accessToken='.length;
        var end = rawCookie.indexOf(';', start);
        return rawCookie.substring(start, end);
      }
    }
    return '';
  }
}