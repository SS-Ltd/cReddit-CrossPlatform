// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/Authentication/widgets/auth_filed.dart';
import 'package:reddit_clone/features/Authentication/forget_password.dart';
import 'package:reddit_clone/features/home_page/custom_navigation_bar.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:reddit_clone/features/Authentication/signup.dart';
import 'package:reddit_clone/features/Authentication/widgets/user_agreement.dart';
import 'package:reddit_clone/features/Authentication/google_button.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'dart:async';

/// The login screen widget.
///
/// This widget displays the login screen of the cReddit app. It allows users to enter their email and password to log in.
/// The screen also provides options for signing up, logging in with Google, and recovering a forgotten password.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<int> isValidNotifier = ValueNotifier<int>(0);
  final ValueNotifier<bool> isFormFilled = ValueNotifier<bool>(false);

  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();
  bool isKeyboardVisible = false;
  StreamSubscription<bool>? _keyboardVisibilitySubscription;

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
    // passwordController.dispose();
    // isValidNotifier.dispose();
    // isFormFilled.dispose();
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
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                }
              },
              child: const Text('Sign Up',
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
                      'Log in to cReddit',
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
                            color: Palette.whiteColor,
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
                            labelText: 'Username',
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          if (mounted) {
                            FocusScope.of(context).unfocus();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetPassword(),
                              ),
                            );
                          }
                        },
                        child: const Text('Forgot Password?',
                            style: TextStyle(
                                color: Palette.deepOrangeColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_keyboardVisibilityController.isVisible,
            child: const AgreementText(),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: isFormFilled,
              builder: (context, isFilled, child) {
                return ElevatedButton(
                  onPressed: isFilled
                      ? () async {
                          if (mounted) {
                            if (_formKey.currentState!.validate()) {         
                              await context.read<NetworkService>().login(
                                  emailController.text,
                                  passwordController.text);
                              final user = context.read<NetworkService>().user;
                              print(user);
                              print(user?.isLoggedIn);
                              if (user != null && user.isLoggedIn) {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomNavigationBar(
                                      isProfile: false,
                                    ),
                                  ),
                                );
                              }
                            }
                          }
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
            ),
          ),
        ],
      ),
    );
  }
}
