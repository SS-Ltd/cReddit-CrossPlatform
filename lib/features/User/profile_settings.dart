import 'package:flutter/material.dart';

class ProfileSettings extends StatelessWidget {
  final String userName;

  const ProfileSettings({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Center(
        child: Text('Settings for $userName'),
      ),
    );
  }
}
