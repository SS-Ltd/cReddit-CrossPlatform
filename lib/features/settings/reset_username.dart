// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';

/// A widget that displays an alert dialog for resetting the username.
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
            child: Text('Unfortunately, if you have never given us your email,'
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
                    _emailController.clear();
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      int changeresponse =
                          await context.read<NetworkService>().resetusername(
                                _emailController.text,
                              );
                      if (changeresponse == 200) {
                        CustomSnackBar(context: context, content: "Please Check Your Email", backgroundColor: Colors.green);
                      }
                    }
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
