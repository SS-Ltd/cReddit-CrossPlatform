import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  bool obscureText;

  AuthField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
  });

  @override
  _AuthFieldState createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  void togglePasswordVisibility() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        obscureText: widget.obscureText,
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.isEmpty || value.trim().isEmpty) {
            return 'Please enter ${widget.labelText}';
          } 
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Palette.redditLightGrey,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Palette.redditBlack),
          ),
          labelText: widget.labelText,
          suffixIcon: widget.labelText == 'Password'
              ? IconButton(
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
