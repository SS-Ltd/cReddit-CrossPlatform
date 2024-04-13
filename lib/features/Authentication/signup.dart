import 'package:flutter/material.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';
import 'package:reddit_clone/features/Authentication/name_suggestion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/google_button.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isFormFilled = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    emailController.addListener(() {
      isFormFilled.value =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });

    passwordController.addListener(() {
      isFormFilled.value =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });

    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
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
                      color: Palette.whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold))),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Hi friend, Sign up!',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Palette.whiteColor),
            ),
            const SizedBox(height: 20),
            const GoogleButton(),
            const Row(
              children: <Widget>[
                Expanded(
                  child: Divider(
                    color: Palette.whiteColor,
                    height: 50,
                  ),
                ),
                Text('   OR   ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Palette.whiteColor)),
                Expanded(
                  child: Divider(
                    color: Palette.redditGrey,
                    height: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Semantics(
                identifier: 'signup_email_field',
                child: AuthField(
                  controller: emailController,
                  labelText: 'Email',
                  showClearButton: true,
                )),
            const SizedBox(height: 20),
            Semantics(
              identifier: 'signup_password_fields',
              child: AuthField(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true),
            ),
            const Expanded(
              child: SizedBox(height: 1), // Replace 1 with the desired height
            ),
            if (!isKeyboardOpen) const AgreementText(),
            const SizedBox(height: 20),
            Visibility(
                visible: !isKeyboardOpen,
                child: ValueListenableBuilder<bool>(
                  valueListenable: isFormFilled,
                  builder: (context, isFilled, child) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill in all fields')),
                          );
                          return;
                        }
                        if (!isValidEmail(emailController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid email address')),
                          );
                          return;
                        }
                        if (!isValidPassword(passwordController.text)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Password must be 8 or more characters and contain at least one uppercase and one lowercase letter')),
                          );
                          return;
                        }
                        Map<String, dynamic> userData = {
                          'email': emailController.text,
                          'password': passwordController.text,
                        };
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NameSuggestion(userData: userData)),
                        );
                      },
                      child: const Text('Continue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isFilled == true ? Colors.deepOrange : Colors.grey,
                        foregroundColor:
                            isFilled == true ? Colors.white : Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }
}
