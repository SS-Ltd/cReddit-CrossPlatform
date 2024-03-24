import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';

class ResetPasswordDone extends StatefulWidget {
  const ResetPasswordDone({super.key});

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
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
                        color: Colors.grey,
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
                ),
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
                          color: Color.fromARGB(255, 107, 106, 106)),
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
                          style: TextStyle(fontSize: 14),
                        ),
                        ValueListenableBuilder(
                          valueListenable: canResend,
                          builder: (context, value, child) {
                            return GestureDetector(
                              onTap: value
                                  ? () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/',
                                      );
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  Text(
                                    'Resend',
                                    style: TextStyle(
                                      color: value ? Colors.black : Colors.grey,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!value)
                                    ValueListenableBuilder(
                                      valueListenable: countdown,
                                      builder: (context, value, child) {
                                        return Text(' in $value');
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
                        await Navigator.pushReplacementNamed(
                          context,
                          '/',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
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
