// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/arrow_button.dart';
import 'package:reddit_clone/features/User/Profile.dart';
import 'package:reddit_clone/models/user.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/User/block_button.dart';
/// A dialog box that displays information about a user.
///
/// This dialog box is used to show details about a user, such as their username,
/// karma points, and options to interact with the user's profile.
class AboutUserPopUp extends StatelessWidget {
  final String userName;

  const AboutUserPopUp({required this.userName, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('u/$userName'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Container(
              height: 200,
              child: Image.asset(
                'assets/hehe.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          ArrowButton(
              onPressed: () async {
                UserModel myUser = await context
                    .read<NetworkService>()
                    .getUserDetails(userName);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      userName: myUser.username,
                      profileName: myUser.username,
                      displayName: myUser.displayName,
                      profilePicture: myUser.profilePicture,
                      followerCount: myUser.followers,
                      about: myUser.about!,
                      cakeDay: myUser.cakeDay.toString(),
                      bannerPicture: myUser.banner!,
                      isOwnProfile: false,
                    ),
                  ),
                );
              },
              buttonText: 'View Profile',
              buttonIcon: Icons.person,
              hasarrow: false),
          Padding(
            padding: const EdgeInsets.all(0),
            child: ArrowButton(
                onPressed: () {},
                buttonText: 'Send Message',
                buttonIcon: Icons.mail_outline,
                hasarrow: false),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: BlockButton(isCircular: false, onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

  