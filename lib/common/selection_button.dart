import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/palette.dart';

class SelectionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final IconData? buttonIcon;
  final String selectedtext;
  final String optional;

  const SelectionButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
    required this.selectedtext,
    this.buttonIcon,
    this.optional = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buttonIcon == null
                    ? const SizedBox()
                    : Icon(
                        buttonIcon,
                        color: Palette.whiteColor,
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    children: [
                      Text(
                        buttonText,
                        style: const TextStyle(
                          color: Palette.whiteColor,
                        ),
                      ),
                      if (optional.isNotEmpty)
                        SizedBox(
                          width: 300,
                          child: Text(
                            optional,
                            style: const TextStyle(color: Palette.whiteColor),
                            softWrap: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  selectedtext,
                  style: const TextStyle(color: Palette.whiteColor),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Palette.whiteColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
