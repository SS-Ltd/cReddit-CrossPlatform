import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:cReddit/features/settings/forgot_password.dart';
import 'package:cReddit/services/networkServices.dart';
import 'package:provider/provider.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() {
    return _UpdateEmailState();
  }
}

class _UpdateEmailState extends State<UpdateEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _emailController.clear();
              _passwordController.clear();
              Navigator.pop(context);
            },
          ),
          title: const Text('Update email address'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('u/username'),
                            Text('usama.nasser21@gmail.com'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ///////////////////////////////////////
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'New email address',
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
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Redddit Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: _toggle,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your password';
                          }
                          // else if (value.length < 8) {
                          //   return 'Password must be at least 8 characters long';
                          // }
                          return null;
                        },
                      ),
                      //////////////////////////////////////////
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
                      Padding(
                        padding: const EdgeInsets.only(top: 360),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _emailController.clear();
                                _passwordController.clear();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(170, 40)),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                 String changeresponse =  await context
                                      .read<NetworkService>()
                                      .updateemail(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                      print(changeresponse);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(170, 40)),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
