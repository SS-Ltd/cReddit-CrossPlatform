import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class AgreementText extends StatelessWidget {
  const AgreementText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: Theme.of(context).textTheme.labelSmall,
          children: [
            const TextSpan(
              text: 'By continuing, you agree to our ',
            ),
            TextSpan(
              text: 'User Agreement ',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Palette.orangeColor,
                  ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  launchUrl(
                      Uri.parse(
                          'https://www.redditinc.com/policies/user-agreement'),
                      mode: LaunchMode.externalApplication);
                },
            ),
            const TextSpan(
              text: 'and acknowledge that you understand the ',
            ),
            TextSpan(
              text: 'Privacy Policy',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Palette.orangeColor,
                  ),
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
      ),
    );
  }
}