import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

/// A widget that represents an authentication field.
///
/// This widget is used to display an input field for authentication purposes,
/// such as username or password. It provides options for showing or hiding the
/// entered text, as well as a clear button to remove the entered text.
///
/// The [AuthField] widget requires a [controller] to manage the text input,
/// a [labelText] to display as the field's label, and optional parameters
/// [obscureText] and [showClearButton] to customize the field's behavior.
///
/// Example usage:
///
/// ```dart
/// AuthField(
///   controller: _usernameController,
///   labelText: 'Username',
///   obscureText: false,
///   showClearButton: true,
/// )
///

class AuthField extends StatefulWidget {
  /// The controller for managing the text input.
  final TextEditingController controller;

  /// The label text to display for the field.
  final String labelText;

  /// Whether the entered text should be obscured (e.g., for passwords).
  bool obscureText;

  /// Whether to show a clear button to remove the entered text.
  final bool showClearButton;

  /// Creates a new [AuthField] instance.
  ///
  /// The [controller] and [labelText] parameters are required.
  /// The [obscureText] parameter defaults to `false`.
  /// The [showClearButton] parameter defaults to `false`.
  AuthField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.showClearButton = false,
  });

  @override
  State<AuthField> createState() {
    return _AuthFieldState();
  }
}

class _AuthFieldState extends State<AuthField> {
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  /// Toggles the visibility of the password text.
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
                key: Key(widget.labelText),
                controller: widget.controller,
                obscureText: widget.obscureText,
                style: const TextStyle(color: Palette.whiteColor),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: const TextStyle(
                    color: Palette.inputFieldLabel,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.only(left: 15, top: 5, bottom: 10),
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
                            errorNotifier.value =
                                'Please enter ${widget.labelText}';
                          },
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                ),
                onChanged: (value) {
                  if (value.isEmpty || value.trim().isEmpty) {
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
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
