import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class ResetPasswordDone extends StatefulWidget {
  const ResetPasswordDone({super.key});

  @override
  State<ResetPasswordDone> createState() => _ResetPasswordDoneState();
}

class _ResetPasswordDoneState extends State<ResetPasswordDone> {
  int delayInSeconds = 5;
  ValueNotifier<bool> canResend = ValueNotifier(false);
  bool canResend2 = false;
  int isValidEmail(String input) {
    // Change this line
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return regex.hasMatch(input) ? 1 : -1;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: delayInSeconds), () {
      setState(() {
        canResend.value = true;
        canResend2 = true;
      });
    });
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
            children: <Widget>[
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
                  children: <Widget>[
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
                  children: <Widget>[
                    const Text(
                      'Didn\'t get an email?',
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
                          child: Text(
                            'Resend',
                            style: TextStyle(
                              color: value ? Colors.blue : Colors.grey,
                            ),
                          ),
                        );
                      },
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
