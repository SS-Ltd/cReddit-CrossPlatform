import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController emailController;
  final ValueNotifier<int> isValidNotifier;
  final String labelText;
  final String invalidText;

  const CustomTextField({
    Key? key,
    required this.emailController,
    required this.isValidNotifier,
    required this.labelText,
    required this.invalidText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: isValidNotifier,
      builder: (BuildContext context, int isValid, Widget? child) {
        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Palette.inputField,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: emailController.text.isEmpty
                      ? Palette.textFormFieldgreyColor
                      : (isValid == 1 ? Colors.green : Colors.red),
                  width: 1.5,
                ),
              ),
              child: TextFormField(
                controller: emailController,
                onChanged: (value) {
                  isValidNotifier.value = isValidEmail(value);
                },
                style: const TextStyle(color: Palette.whiteColor),
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: const TextStyle(
                    color: Palette.inputFieldLabel,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 10),
                  suffixIcon: emailController.text.isNotEmpty
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            isValidNotifier.value == 1
                                ? const Icon(Icons.check_sharp,
                                    color: Colors.green)
                                : const Icon(Icons.error_outline,
                                    color: Colors.red),
                            IconButton(
                              onPressed: () {
                                emailController.clear();
                                isValidNotifier.value = 0;
                              },
                              icon: const Icon(Icons.clear),
                            ),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (isValid == -1 && emailController.text.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    invalidText,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

int isValidEmail(String input) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  final RegExp usernameRegex = RegExp(
    r'^[a-zA-Z0-9_-]*$',
  );

  if (input.isEmpty) {
    return -1;
  } else if (emailRegex.hasMatch(input) || usernameRegex.hasMatch(input)) {
    return 1;
  } else {
    return -1;
  }
}