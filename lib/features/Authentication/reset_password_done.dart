import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'package:reddit_clone/theme/palette.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/NetworkServices.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'dart:io' show Platform;
import 'package:logging/logging.dart';
//import 'package:android_intent_plus/android_intent.dart';

class ResetPasswordDone extends StatefulWidget {
  String email;
  ResetPasswordDone({required this.email, super.key});

  @override
  State<ResetPasswordDone> createState() => _ResetPasswordDoneState();
}

class _ResetPasswordDoneState extends State<ResetPasswordDone> {
  ValueNotifier<int> countdown = ValueNotifier<int>(5);
  Timer? timer;
  ValueNotifier<bool> canResend = ValueNotifier(false);
  //bool canResend2 = false;

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 1) {
        countdown.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    timer?.cancel();
    countdown.dispose();
    canResend.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Palette.redditLogin,
        appBar: AppBar(
          backgroundColor: Palette.redditLogin,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Image.asset(
            'assets/reddit_icon.png',
            fit: BoxFit.cover,
            height: 50,
          ),
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
                'Check your inbox',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Palette.whiteColor),
              ),
              const SizedBox(height: 18),
              //Sub Heading
              const Center(
                child: Column(
                  children: [
                    Text(
                      'We send a password reset link to the email '
                      'associated with your account',
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

              // Avatar Reset Page Image
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset('assets/reddit_char.png'),
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t get an email? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Palette.whiteColor,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: canResend,
                          builder: (context, value, child) {
                            return GestureDetector(
                              onTap: value
                                  ? () async {
                                      bool reset = await context
                                          .read<NetworkService>()
                                          .forgotPassword(widget.email);
                                      if (mounted && reset) {
// Show a message to the user indicating that the email was resent successfully.
                                        CustomSnackBar(
                                          context: context,
                                          content: 'Email resent successfully',
                                        ).show();
                                      }
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  Text(
                                    'Resend',
                                    style: TextStyle(
                                      color: value
                                          ? Palette.blueColor
                                          : Palette.greyColor,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!value)
                                    ValueListenableBuilder(
                                      valueListenable: countdown,
                                      builder: (context, value, child) {
                                        return Text(
                                          ' in $value',
                                          style: const TextStyle(
                                              color: Palette.whiteColor),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // final Logger logger = Logger('ResetPasswordDone');
                        // if (Platform.isAndroid) {
                        //   AndroidIntent intent = const AndroidIntent(
                        //     action: 'android.intent.action.MAIN',
                        //     package: 'com.google.android.gm',
                        //     category: 'android.intent.category.LAUNCHER',
                        //   );
                        //   intent.launch().catchError((e) {
                        //     logger.severe("Error opening Gmail app: $e");
                        //   });
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.deepOrangeColor,
                        foregroundColor: Palette.whiteColor,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('Open email app'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
