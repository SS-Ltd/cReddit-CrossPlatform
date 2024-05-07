import 'package:flutter/material.dart';
import 'package:reddit_clone/features/User/profile_settings.dart';

/// A button widget used for editing user profiles.
///
/// This button is typically used in user profile screens to allow users to edit their profile information.
class EditButton extends StatelessWidget {
  final String userName;

  const EditButton({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          // Add functionality to edit user profile given the username
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileSettings(userName: userName)),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.transparent,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: Colors.white, width: 2.0),
            ),
          ),
        ),
        child: const Text(
          'Edit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ));
  }
}
