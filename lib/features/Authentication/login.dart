import 'package:flutter/material.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:reddit_clone/common/ImageButton.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            SvgPicture.asset(AssetsConstants.redditLogo, width: 50, height: 50),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text('Sign Up',
                  style: TextStyle(
                      color: Palette.redditGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Log in to Reddit',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                ImageButton(
                  text: 'Continue with Google',
                  onPressed: () {},
                  iconPath: AssetsConstants.googleLogo,
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: FullWidthButton(text: "Continue", onPressed: () {}),
        )
      ],
    );
  }
}
