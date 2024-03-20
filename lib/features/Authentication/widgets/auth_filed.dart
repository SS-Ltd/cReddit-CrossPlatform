import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  bool obscureText;

  AuthField({
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
  Widget build(BuildContext context) {
    return Container(
      height: 55.0,
      child: TextFormField(
        obscureText: widget.obscureText,
        controller: widget.controller,
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
