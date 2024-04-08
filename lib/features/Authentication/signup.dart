import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/common/ImageButton.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      appBar: AppBar(
        title:
            SvgPicture.asset(AssetsConstants.redditLogo, width: 50, height: 50),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Log In',
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
            const Text('Hi friend, Sign up!',
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
                controller: emailController, labelText: 'Email or Username'),
            const SizedBox(height: 20),
            AuthField(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true),
            const Expanded(
              child: SizedBox(height: 1), // Replace 1 with the desired height
            ),
            if (!isKeyboardOpen) const AgreementText(),
            const SizedBox(height: 20),
            FullWidthButton(
                text: "Continue",
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    // Show an error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }
                  bool signup = await context.read<NetworkService>().createUser(
                      "osama2001",
                      emailController.text,
                      passwordController.text,
                      "Man");
                  if (signup) {
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to sign up')),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
