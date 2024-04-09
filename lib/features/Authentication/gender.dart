import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/features/home_page/widgets/custom_navigation_bar.dart';

class Gender extends StatelessWidget {
  final Map<String, dynamic> userData;
  Gender({Key? key, required this.userData}) : super(key: key);

  final List<String> userGender = [
    "Man",
    "Woman",
    "I Prefer Not To Say",
    "None"
  ];

  void signup(BuildContext context) async {
    bool signup = await context.read<NetworkService>().createUser(
        userData["username"],
        userData["email"],
        userData["password"],
        userData["gender"]);
    if (signup) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CustomNavigationBar()));
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
      backgroundColor: Palette.redditLogin,
      appBar: AppBar(
        backgroundColor: Palette.redditLogin,
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
            child: Text(
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
                Text(
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
                      child:
                          Text(gender, style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      //style for button using the predefined style in the palette
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
