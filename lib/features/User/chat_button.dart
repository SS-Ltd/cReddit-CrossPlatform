import 'package:flutter/material.dart';

class ChatButton extends StatelessWidget {
  final String userName;
  final String profileName;

  const ChatButton({
    super.key, 
    required this.userName,
    required this.profileName, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add functionality to edit user profile given the username
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.transparent,
        ),
        shape: MaterialStateProperty.all<CircleBorder>(
          const CircleBorder(
            side: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
        ),
      ),
      child: const Icon(
        Icons.chat,
        color: Colors.white,
        size: 24.0,
      )
    );
  }
}