import 'package:flutter/material.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/features/home_page/home_page.dart';
import 'package:reddit_clone/features/Authentication/forget_password.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:reddit_clone/common/ImageButton.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthField(
                      controller: emailController,
                      labelText: 'Email or Username'),
                  const SizedBox(height: 20),
                  AuthField(
                      controller: passwordController,
                      labelText: 'Password',
                      obscureText: true),
                ],
              ),
            ),
            if (!isKeyboardOpen) const SizedBox(height: 10),
            if (!isKeyboardOpen)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPassword(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?',
                      style: TextStyle(
                          color: Palette.redditBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            const Expanded(
              child: SizedBox(height: 1), // Replace 1 with the desired height
            ),
            if (!isKeyboardOpen) const AgreementText(),
            const SizedBox(height: 20),
            FullWidthButton(
              text: "Continue",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
