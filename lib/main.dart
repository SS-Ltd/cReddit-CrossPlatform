import 'package:flutter/material.dart';
import 'forget_password.dart';
import 'reset_password_done.dart';
void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const ForgetPassword(),
      '/reset_password_done': (context) => const ResetPasswordDone(),
    },
  ));
}