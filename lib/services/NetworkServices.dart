import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:reddit_clone/models/user.dart';

class NetworkService extends ChangeNotifier {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  NetworkService._internal();

  String _baseUrl = 'http://10.0.2.2:3000/user';
  String _cookie = '';
  UserModel? _user;
  UserModel? get user => _user;

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
      print('User Settings: ${response.body}');
    } else {
      print('Failed to fetch user settings: ${response.body}');
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
