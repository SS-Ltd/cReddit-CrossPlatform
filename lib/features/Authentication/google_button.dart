import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:reddit_clone/common/ImageButton.dart';
import 'package:reddit_clone/services/google_service.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/home_page/widgets/custom_navigation_bar.dart';

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
  const GoogleButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ImageButton(
      text: 'Continue with Google',
      onPressed: () async {
        bool isAuthenticated =
            await Provider.of<GoogleService>(context, listen: false)
                .handleGoogleSignIn();
        if (!isAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sign in with Google')),
          );
          return;
        }
        String googleAccessToken =
            await Provider.of<GoogleService>(context, listen: false)
                .accessToken!;
        bool isValidated = await context
            .read<NetworkService>()
            .sendGoogleAccessToken(googleAccessToken);
        if (!isValidated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to sign in with Google')),
          );
          return;
        }

        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomNavigationBar()),
        );
      },
      iconPath: AssetsConstants.googleLogo,
    );
  }
}
