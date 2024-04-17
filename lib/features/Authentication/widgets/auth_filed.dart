import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  bool obscureText;
  final bool showClearButton;

  AuthField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.showClearButton = false,
  }) : super(key: key);

  @override
  State<AuthField> createState() {
    return _AuthFieldState();
  }
}

class _AuthFieldState extends State<AuthField> {
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  void togglePasswordVisibility() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  void dispose() {
    widget.controller.dispose();
    errorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Palette.inputField,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.controller.text.isEmpty
                  ? Palette.textFormFieldgreyColor
                  : Palette.transparent,
              width: 1.5,
            ),
          ),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                style: const TextStyle(color: Palette.whiteColor),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: const TextStyle(
                    color: Palette.inputFieldLabel,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 10),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.labelText == 'Password')
                        IconButton(
                          icon: Icon(
                            widget.obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: togglePasswordVisibility,
                        ),
                      if (widget.showClearButton && value.text.isNotEmpty)
                        IconButton(
                          onPressed: () {
                            widget.controller.clear();
                            errorNotifier.value = 'Please enter ${widget.labelText}';
                          },
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                ),
                onChanged: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    errorNotifier.value = 'Please enter ${widget.labelText}';
                  } else {
                    errorNotifier.value = null;
                  }
                },
              );
            },
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: errorNotifier,
          builder: (context, error, child) {
            return error == null || error.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}