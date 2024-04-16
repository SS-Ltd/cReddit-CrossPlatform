import 'package:flutter/material.dart';
import 'package:reddit_clone/common/FullWidthButton.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:reddit_clone/features/Authentication/login.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';
import 'package:reddit_clone/features/Authentication/name_suggestion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/google_button.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:reddit_clone/utils/utils_validate.dart';
import 'dart:async';

/// The screen for user sign up.
///
/// This screen allows users to sign up by providing their email and password.
/// It includes form validation and enables the sign-up button only when the
/// email and password fields are filled.
class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

/// The state of the [SignUpScreen].
///
/// This class manages the state of the sign-up screen, including the text
/// editing controllers for the email and password fields, the form validation,
/// and the visibility of the keyboard. It also handles the navigation to the
/// login screen and the sign-up button's functionality.
class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isFormFilled = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  StreamSubscription<bool>? _keyboardVisibilitySubscription;

  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    _keyboardVisibilitySubscription =
        _keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted) {
        setState(() {
          isKeyboardVisible = visible;
        });
      }
    });
  }

  @override
  void dispose() {
    //emailController.dispose();
    //passwordController.dispose();
    //isFormFilled.dispose();
    _keyboardVisibilitySubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    emailController.addListener(() {
      if (!mounted) return;
      isFormFilled.value =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });

    passwordController.addListener(() {
      if (!mounted) return;
      isFormFilled.value =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });

    //final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthField(
                            controller: emailController,
                            labelText: 'Email',
                            showClearButton: true,
                          ),
                          const SizedBox(height: 20),
                          AuthField(
                              controller: passwordController,
                              labelText: 'Password',
                              obscureText: true),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_keyboardVisibilityController.isVisible,
            child: const AgreementText(),
          ),
          // if (!isKeyboardOpen) const AgreementText(),
          // const SizedBox(height: 20),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: isFormFilled,
                builder: (context, isFilled, child) {
                  return ElevatedButton(
                    onPressed: isFilled
                        ? () async {
                            // Your code...
                          }
                        : null,
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
                    child: const Text('Continue'),
                  );
                },
              )),
        ],
      ),
    );
  }
  /// Checks if the given [email] is a valid email address.
  ///
  /// Returns `true` if the email is valid, otherwise `false`.
  bool isValidEmail(String email) {
    return isValidEmailOrUsername(email) > 0;
  }
}
