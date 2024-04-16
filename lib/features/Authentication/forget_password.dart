import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'reset_password_done.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/constants/assets_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/common/CustomTextField.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';

/// A screen widget for the forget password feature.
///
/// This widget allows the user to reset their password by providing their email
/// address or username. It sends a link to the user's email address to reset
/// their password.
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<int> isValidNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    emailController.dispose();
    isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        appBar: AppBar(
          backgroundColor: Palette.backgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: SvgPicture.asset(AssetsConstants.redditLogo,
              width: 50, height: 50),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RichText(
                text: TextSpan(
                  text: 'Help',
                  style: DefaultTextStyle.of(context).style.copyWith(
                        color: Palette.whiteColor,
                        fontSize: 14.0,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      final url = Uri.parse(
                          'https://support.reddithelp.com/hc/en-us/articles/205240005-How-do-I-log-in-to-Reddit-if-I-forgot-my-password'); // Replace with your website URL
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Heading
              const Text(
                'Reset your Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Palette.whiteColor,
                ),
              ),
              const SizedBox(height: 18),
              //Sub Heading
              const Center(
                child: Column(
                  children: [
                    Text(
                      'Enter your email address or username and we\'ll '
                      'send you a link to reset your password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Palette.whiteColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              CustomTextField(
                controller: emailController,
                isValidNotifier: isValidNotifier,
                labelText: 'Email or Username',
                invalidText: 'Not a valid email address',
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: isValidNotifier,
                      builder: (context, isValid, child) {
                        return ElevatedButton(
                          onPressed: isValid == 1
                              ? () async {
                                  //submit();
                                  bool reset = await context
                                      .read<NetworkService>()
                                      .forgotPassword(emailController.text);
                                  // Hide the keyboard
                                  FocusScope.of(context).unfocus();
                                  if (reset) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ResetPasswordDone(
                                                  email: emailController.text)),
                                    );
                                    CustomSnackBar(
                                            context: context,
                                            content: 'Email sent successfuly')
                                        .show();
                                  } else {
                                    CustomSnackBar(
                                            context: context,
                                            content: 'Email not found')
                                        .show();
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isValid == 1 ? Colors.deepOrange : Colors.grey,
                            foregroundColor:
                                isValid == 1 ? Colors.white : Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: const Text('Reset Password'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}