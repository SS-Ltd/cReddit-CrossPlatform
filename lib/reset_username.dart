import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:email_validator/email_validator.dart';

class ResetUsername extends StatefulWidget {
  const ResetUsername({super.key});

  @override
  State<ResetUsername> createState() {
    return _ResetUsernameState();
  }
}

class _ResetUsernameState extends State<ResetUsername> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Recover username?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email address for your account',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an email address.';
                } else if (!(EmailValidator.validate(value))) {
                  return 'Please enter a valid email address.';
                }
                return null;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Unfortunatly, if you have never given us your email,'
                ' we will not be able to reset your password.'),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () => setState(() {
                        launchUrl(
                            Uri.parse(
                                'https://support.reddithelp.com/hc/en-us/articles/205240005-How-do-I-log-in-to-Reddit-if-I-forgot-my-password'),
                            mode: LaunchMode.externalApplication);
                      }),
                  child: const Text('Having Trouble?',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue,
                      ))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  child: const Text('EMAIL ME'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
