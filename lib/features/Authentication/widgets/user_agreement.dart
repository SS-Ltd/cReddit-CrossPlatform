import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreementText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
              text: 'By continuing up, you agree to the ',
              style: TextStyle(
                  color: Palette.redditBlack,
                  fontSize: 12,
                  decoration: TextDecoration.none)),
          TextSpan(
            text: 'User Agreement ',
            style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                decoration: TextDecoration.none),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Open link in browser
                // launchUrl(Uri(
                //     scheme: 'https',
                //     host: 'www.redditinc.com',
                //     path: '/policies/user-agreement'));
              },
          ),
          TextSpan(
              text: 'and ',
              style: TextStyle(
                  color: Palette.redditBlack,
                  fontSize: 12,
                  decoration: TextDecoration.none)),
          TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  decoration: TextDecoration.none),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Open link in browser
                  //   launchUrl(Uri(
                  //       scheme: 'https',
                  //       host: 'www.reddit.com',
                  //       path: '/policies/privacy-policy'));
                  // },
                }),
          TextSpan(
              text: ' of Reddit.',
              style: TextStyle(
                  color: Palette.redditBlack,
                  fontSize: 12,
                  decoration: TextDecoration.none)),
        ],
      ),
    );
  }
}
