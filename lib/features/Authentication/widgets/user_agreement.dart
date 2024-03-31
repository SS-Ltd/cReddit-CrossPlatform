import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreementText extends StatelessWidget {
  const AgreementText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: 'By continuing, you agree to our ',
                    style: TextStyle(
                        color: Palette.redditBlack,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                  ),
                  TextSpan(
                    text: 'User Agreement ',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                            Uri.parse(
                                'https://www.redditinc.com/policies/user-agreement'),
                            mode: LaunchMode.externalApplication);
                      },
                  ),
                  const TextSpan(
                    text: 'and acknowledge',
                    style: TextStyle(
                        color: Palette.redditBlack,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: 'that you understand the ',
                    style: TextStyle(
                        color: Palette.redditBlack,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                            Uri.parse(
                                'https://www.reddit.com/policies/privacy-policy'),
                            mode: LaunchMode.externalApplication);
                      },
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
