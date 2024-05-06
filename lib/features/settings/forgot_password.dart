// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/features/settings/reset_username.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:email_validator/email_validator.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/services/networkServices.dart';

/// A widget that displays a dialog for resetting a user's password.
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      alignment: Alignment.center,
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
                  'Forgot your password?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ResetUsername();
                          },
                        );
                      },
                      child: const Text('Forgot username'),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
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
                //////////////////////////////////////////
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('Unfortunately, if you have never given us your email,'
                ' we will not be able to reset your password.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    _userNameController.clear();
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
                          await context.read<NetworkService>().resetpassword(
                                _emailController.text,
                                _userNameController.text,
                              );
                      if (changeresponse == 200) {
                        CustomSnackBar(
                            context: context,
                            content: "Please Check Your Email",
                            backgroundColor: Colors.green);
                      } else if (changeresponse == 404) {
                        CustomSnackBar(
                            context: context,
                            content: "User not found",
                            backgroundColor: Colors.red);
                      }
                    }
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
