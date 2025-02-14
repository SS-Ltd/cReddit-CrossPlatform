// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:reddit_clone/common/ImageButton.dart';
import 'package:reddit_clone/services/google_service.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';

/// A button widget that allows users to sign in with Google.
///
/// This button is typically used in the authentication process to provide
/// users with the option to sign in using their Google account. When pressed,
/// it triggers the Google sign-in process and validates the user's access token.
/// If the sign-in is successful and the access token is validated, the user is
/// redirected to the home screen of the application.
///
/// Example usage:
///
/// ```dart
/// GoogleButton(
///   onPressed: () {
///     // Perform Google sign-in and validation logic
///   },
/// )
/// ```
class GoogleButton extends StatelessWidget {
  final String? fcmToken;
  const GoogleButton({super.key, this.fcmToken});

  @override
  Widget build(BuildContext context) {
    return ImageButton(
      text: 'Continue with Google',
      onPressed: () async {
        bool isAuthenticated =
            await Provider.of<GoogleService>(context, listen: false)
                .handleGoogleSignIn();
        if (!isAuthenticated) {
          CustomSnackBar(
              context: context, content: 'Failed to sign in with Google');
          return;
        }
        String googleAccessToken =
            await Provider.of<GoogleService>(context, listen: false)
                .accessToken!;
        bool isValidated = await context
            .read<NetworkService>()
            .sendGoogleAccessToken(googleAccessToken, fcmToken);
        if (!isValidated) {
          CustomSnackBar(
              context: context, content: 'Failed to sign in with Google');
          return;
        }

        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomNavigationBar(
                    isProfile: false,
                  )),
        );
      },
      iconPath: AssetsConstants.googleLogo,
    );
  }
}
