import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:reddit_clone/utils/utils_validate.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<int> isValidNotifier;
  final String labelText;
  final String invalidText;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.isValidNotifier,
    required this.labelText,
    required this.invalidText,
  });

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
                  color: controller.text.isEmpty
                      ? Palette.textFormFieldgreyColor
                      : (isValid == 1 ? Colors.green : Colors.red),
                  width: 1.5,
                ),
              ),
              child: TextFormField(
                controller: controller,
                onChanged: (value) {
                  isValidNotifier.value = isValidEmailOrUsername(value);
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
                  suffixIcon: controller.text.isNotEmpty
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
                                controller.clear();
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
            if (isValid == -1 && controller.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    invalidText,
                    style: const TextStyle(
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
