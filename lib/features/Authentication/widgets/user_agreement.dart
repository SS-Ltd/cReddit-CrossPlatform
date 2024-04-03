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
                children: [
                  TextSpan(
                    style: Theme.of(context).textTheme.labelSmall,
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
                  TextSpan(
                    style: Theme.of(context).textTheme.labelSmall,
                    text: 'and acknowledge',
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
                style: Theme.of(context).textTheme.labelSmall,
                children: [
                  TextSpan(
                    text: 'that you understand the ',
                    style: Theme.of(context).textTheme.labelSmall,
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
            )
          ],
        ),
      ],
    );
  }
}
