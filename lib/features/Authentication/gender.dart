import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/home_page/widgets/custom_navigation_bar.dart';

/// A widget that represents the gender selection screen for user signup.
///
/// This widget displays a list of gender options and allows the user to select
/// their gender. The selected gender is stored in the [userData] map.
/// The user can sign up by calling the [signup] method, which sends the user's
/// signup data to the server and navigates to the home screen upon successful.
///
/// The [Gender] widget is typically used as part of the signup process in the
/// authentication feature of the cReddit-CrossPlatform app.
class Gender extends StatelessWidget {
  final Map<String, dynamic> userData;

  /// Constructs a [Gender] widget.
  ///
  /// The [userData] parameter is a map that contains the user's signup data,
  /// including their username, email, password, and gender.
  Gender({super.key, required this.userData});

  final List<String> userGender = [
    "Man",
    "Woman",
    "I Prefer Not To Say",
    "None"
  ];

  /// Signs up the user with the provided signup data.
  ///
  /// The [context] parameter is the build context of the widget.
  /// This method calls the [createUser] method of the [NetworkService] to send
  /// the user's signup data to the server. If the signup is successful, it
  /// navigates to the home screen using the [CustomNavigationBar] widget.
  /// Otherwise, it displays a snackbar with an error message.
  void signup(BuildContext context) async {
    bool signup = await context.read<NetworkService>().createUser(
        userData["username"],
        userData["email"],
        userData["password"],
        userData["gender"]);
    if (signup) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomNavigationBar(
                    isProfile: false,
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign up')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userData["gender"] = "None";
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        title: SvgPicture.asset(
          AssetsConstants.redditLogo,
          width: 50,
          height: 50,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Handle skip action
              signup(context);
            },
            child: const Text(
              "Skip",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'How do you identify?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Palette.whiteColor,
                  ),
                ),
                const SizedBox(height: 20),
                ...userGender.map(
                  (gender) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        userData['gender'] = gender;
                        signup(context);
                        // Handle gender selection
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(gender,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !isKeyboardOpen,
              child: FullWidthButton(
                text: "Continue",
                onPressed: () async {
                  signup(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
