import "package:flutter/material.dart";

/// A widget that represents a blocked user in the settings.
class BlockedUser extends StatelessWidget {
  const BlockedUser(
      {super.key,
      required this.onPressed,
      required this.username,
      required this.userphoto});

  /// A callback function that is called when the unblock button is pressed.
  final VoidCallback onPressed;

  /// The username of the blocked user.
  final String username;

  /// The photo of the blocked user.
  final String userphoto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Username'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                    const Size(100, 10),
                  ),
                  textStyle: MaterialStateProperty.all(
                    const TextStyle(fontSize: 14),
                  ),
                ),
                onPressed: () {},
                child: const Text('Unblock'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
