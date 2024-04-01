import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/models/user_settings.dart';

class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  NetworkService._internal();

  String _baseUrl = 'http://10.0.2.2:3000/user';
  String _cookie = '';
  UserModel? _user;
  UserModel? get user => _user;
  UserSettings? _userSettings;
  UserSettings? get userSettings => _userSettings;

  Future<void> login(String username, String password) async {
    print('Logging in...');
    Uri url = Uri.parse('$_baseUrl/login');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      _updateCookie(response);
      _user = UserModel(username);
      _user!.updateUserStatus(true);
      print('Logged in. Cookie: $_cookie');
    } else {
      print('Login failed: ${response.body}');
    }
    notifyListeners();
  }

  Future<void> logout() async {
    Uri url = Uri.parse('$_baseUrl/logout');
    final response = await http.get(url, headers: _headers);
    print('Logged out: ${response.body}');
  }

  Future<void> getUserSettings() async {
    Uri url = Uri.parse('$_baseUrl/settings');
    final response = await http.get(url, headers: _headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      _userSettings = UserSettings.fromJson(json);
      notifyListeners(); // Notify listeners to update UI or other components listening to changes
    } else {
      print('Failed to fetch user settings: ${response.body}');
    }
  }

  Future<bool> forgotPassword(String username, String email) async {
    final url = Uri.parse('$_baseUrl/forgot-password');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUser(
      String username, String email, String password, String gender) async {
    final url = Uri.parse(_baseUrl);
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
      return true;
    } else {
      print('Failed to create user: ${response.body}');
      return false;
    }
  }

  Future<void> refreshToken() async {
    Uri url = Uri.parse('$_baseUrl/refresh-token');
    final response = await http.get(url, headers: _headers);
    print(_headers);
    if (response.statusCode == 200) {
      _updateCookie(response);
      print('Token refreshed successfully. New Cookie: $_cookie');
    } else {
      print('Failed to refresh token: ${response.body}');
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
