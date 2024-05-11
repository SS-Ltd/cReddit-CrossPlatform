//--coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleService extends ChangeNotifier {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;
  String? _accessToken;
  String? get accessToken => _accessToken;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>['email'],
  );

  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isAuthorized => _isAuthorized;

  Future<bool> handleGoogleSignIn() async {
    print('Signing in with Google...');
    try {
      await _googleSignIn.signIn();
      if (_googleSignIn.currentUser != null) {
        _currentUser = _googleSignIn.currentUser;
        _isAuthorized = true;
        GoogleSignInAuthentication? authentication =
            await _currentUser?.authentication;

        // Check if authentication is not null
        if (authentication != null) {
          // Retrieve the access token
          _accessToken = authentication.accessToken;
          print('Access token: $accessToken');
        } else {
          print('Authentication object is null');
        }

        notifyListeners();
        print('User email: ${_currentUser?.email}');
        return true;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
      _isAuthorized = false;
      notifyListeners();
    } catch (error) {
      print('Error signing out: $error');
    }
  }
}
