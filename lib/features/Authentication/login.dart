import 'package:flutter/material.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Log in to Reddit',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ImageButton(
              text: 'Continue with Google',
              onPressed: () {},
              iconPath: AssetsConstants.googleLogo,
            ),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Palette.redditGrey,
                    height: 50,
                  ),
                ),
                Text('   OR   ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Palette.redditDarkGrey)),
                Expanded(
                  child: Divider(
                    color: Palette.redditGrey,
                    height: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AuthField(
                controller: TextEditingController(), labelText: 'Username'),
            const SizedBox(height: 20),
            AuthField(
                controller: TextEditingController(),
                labelText: 'Password',
                obscureText: true),
          ],
        ),
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
