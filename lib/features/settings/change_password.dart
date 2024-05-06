// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:reddit_clone/common/CustomSnackBar.dart';
import 'package:reddit_clone/features/settings/forgot_password.dart';
import 'package:reddit_clone/services/networkServices.dart';
import 'package:provider/provider.dart';

/// A widget that allows the user to change their password.
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() {
    return _ChangePasswordState();
  }
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureTextCurrent = true;
  bool _obscureTextNew = true;
  bool _obscureTextConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleCurrent() {
    setState(() {
      _obscureTextCurrent = !_obscureTextCurrent;
    });
  }

  void _toggleNew() {
    setState(() {
      _obscureTextNew = !_obscureTextNew;
    });
  }

  void _toggleConfirm() {
    setState(() {
      _obscureTextConfirm = !_obscureTextConfirm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text('u/username'),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: _obscureTextCurrent,
                        decoration: InputDecoration(
                          labelText: 'Current password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextCurrent
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _toggleCurrent,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your current password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const ForgotPassword();
                                },
                              );
                            },
                            child: const Text('Forgot password?'),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _obscureTextNew,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextNew
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _toggleNew,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureTextConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm new password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureTextConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _toggleConfirm,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your password';
                          } else if (value != _newPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 340),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _currentPasswordController.clear();
                                  _newPasswordController.clear();
                                  _confirmPasswordController.clear();
                                  Navigator.pop(context);
                                },
                                // style: ElevatedButton.styleFrom(
                                //     minimumSize: const Size(150, 40)),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    int changeresponse = await context
                                        .read<NetworkService>()
                                        .updatepassword(
                                            _newPasswordController.text,
                                            _confirmPasswordController.text,
                                            _currentPasswordController.text);
                                    if (changeresponse == 200) {
                                      CustomSnackBar(context: context, content: "Password Changed Successfully", backgroundColor: Colors.green);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 40)),
                                child: const Text('Save'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
