import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final String userName;

  const EditButton({Key? key, required this.userName}) : super(key: key);

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
      )
    );
  }
}